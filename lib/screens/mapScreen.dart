import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_markers/map_markers.dart';
import 'package:transporter/models/bricole.dart';
import 'package:transporter/services/database.dart';
import 'package:transporter/widgets/bricole_marker.dart';
import 'package:transporter/widgets/bricole_page.dart';


class MapScreen extends StatefulWidget {
  static const String route = '/live_location';
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const MapScreen({Key key, this.auth, this.firestore}) : super(key: key);
  
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData _currentLocation;
  MapController _mapController;

  bool _liveUpdate = true;
  bool _permission = false;

  String _serviceError = '';

  final Location _locationService = Location();
  var markers=<Marker>[];
  
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();

  }

  void _addMarker(GeoPoint geoPoint, String description, String userContact, String imgURL) {
      Marker _marker = Marker(
        width: 35.0,
        height: 35.0,
        point: LatLng(geoPoint.latitude,geoPoint.longitude),
        builder: (BuildContext context) {
          return BricoleMarker(
            imageAsset: imgURL,
            name: "demenagemnt",
            widgetBuilder: (BuildContext context) {
              return Icon(Icons.location_on,
                  size: 35.0, color: Colors.orangeAccent);
            },
            routeBuilder: (BuildContext context) =>
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
              return BricolePage(tag: description, userContact: userContact, imgURL: imgURL);
            })),
          );
        });
      //setState(() {
        markers.add(_marker);
      //});
    }
    void _updateMarkers(List<BricoleModel> documentList) {
      markers.clear();
      documentList.forEach((BricoleModel document) {
        GeoPoint point = document.bricoleLocation;
        _addMarker(point,document.description,widget.auth.currentUser.phoneNumber.toString(),document.bricoleimgURL);
        print('marker added to markers');
        print(document.description);
        print(document.bricoleId.toString());
        print(document.bricoleimgURL.toString());
      });
    }
  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        var permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService
              .onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;

                // If Live Update is enabled, move map center
                if (_liveUpdate) {
                  _mapController.move(
                      LatLng(_currentLocation.latitude,
                          _currentLocation.longitude),
                      _mapController.zoom);
                }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;

    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation.latitude, _currentLocation.longitude);
    } else {
      currentLatLng = LatLng(0, 0);
    }
    Marker myMarker =
      Marker(
        width: 80.0,
        height: 80.0,
        point: currentLatLng,
        builder: (context) => BubbleMarker(
                      bubbleColor: Colors.grey,
                      bubbleContentWidgetBuilder: (BuildContext context) {
                        return const Text("You");
                      },
    ));
   
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: _serviceError.isEmpty
                  ? Text('Current Lat Long '
                      '(${currentLatLng.latitude}, ${currentLatLng.longitude}).')
                  : Text(
                      'Error occured while acquiring location. Error Message : '
                      '$_serviceError'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: StreamBuilder(
                stream: Database(firestore: widget.firestore)
                    .streamLocations(uid: widget.auth.currentUser.uid),
                builder: (BuildContext context, AsyncSnapshot<List<BricoleModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    _updateMarkers(snapshot.data);
                    markers.add(myMarker);
                    if (snapshot.data.isEmpty) {
                      return const Center(
                        child: Text("No Bricoles near you"),
                      );
                    }
                    return Text('Total Available bricoles is ' '${snapshot.data.length}');
                  } 
                  else {
                   return const Center(
                     child: Text("loading Bricoles..."),
                     );
                  }
                }
              )
            ),
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center:
                    LatLng(currentLatLng.latitude, currentLatLng.longitude),
                  zoom: 13.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                    subdomains: ['a', 'b', 'c','d'],
                    // For example purposes. It is recommended to use
                    // TileProvider with a caching and retry strategy, like
                    // NetworkTileProvider or CachedNetworkTileProvider
                    tileProvider: NonCachingNetworkTileProvider(),
                  ),
                  MarkerLayerOptions(
                    markers: markers
                  ),
                ]
              ))
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _liveUpdate = !_liveUpdate,
        child: _liveUpdate ? Icon(Icons.location_on) : Icon(Icons.location_off),
        backgroundColor: Colors.grey,
      ),
    );
  }
          
}
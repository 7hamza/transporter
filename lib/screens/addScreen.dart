import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:transporter/services/database.dart';


class AddScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const AddScreen({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  
  final TextEditingController _bricoleController = TextEditingController();

  LocationData location;
  LocationData _currentLocation;
  final Location _locationService = Location();
  GeoPoint _currentGeoPoint;

  bool useCurrentLocation = false;
  bool _permission = false;

  String _serviceError = '';

  @override
  void initState() {
    super.initState();
    initLocationService();
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
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Add Bricole",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: const ValueKey("addField"),
                          controller: _bricoleController,
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CheckboxListTile(title: Text("Use current Location"),value: useCurrentLocation, onChanged: (value){
                setState(() {
                  useCurrentLocation = true;
                });
              },),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                key: const ValueKey("addButton"),
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_bricoleController.text != "" && useCurrentLocation == true) {
                    setState(() {
                      Database(firestore: widget.firestore).addBricole(
                          uid: widget.auth.currentUser.uid,
                          content: _bricoleController.text,
                          location: GeoPoint(_currentLocation.latitude,_currentLocation.longitude));
                      _bricoleController.clear();
                      useCurrentLocation = false;
                    });
                  }
                },
              )
            ])
        )
      )
    );
  }
}
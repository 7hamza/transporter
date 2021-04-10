import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final FirebaseAuth auth;
  //final FirebaseStorage storage;
  ProfileScreen({Key key, this.auth}) : super(key: key);

  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String imgUrl;
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    uploadImage(int camera) async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;


    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted){
      //Select Image
      if(camera==0){
        image = await _picker.getImage(source: ImageSource.camera);
      }
      else{
        image = await _picker.getImage(source: ImageSource.gallery);
      }

      var file = File(image.path);

      if (image != null){
        //Upload to Firebase
        var snapshot = await _storage.refFromURL('gs://transporter-67539.appspot.com/')
        .child('profile/'+widget.auth.currentUser.uid)
        .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        await widget.auth.currentUser.updateProfile(photoURL: downloadUrl);

        setState(() {
          imgUrl = downloadUrl;
          print(downloadUrl);
        });
      } else {
        print('No Path Received');
      }

    } else {
      print('Grant Permissions and try again');
    }
  }
    return new Stack(children: <Widget>[
      new Container(color: Colors.black,),
      new Image.network(widget.auth.currentUser.photoURL, fit: BoxFit.fill,),
      new BackdropFilter(
      filter: new ui.ImageFilter.blur(
      sigmaX: 6.0,
      sigmaY: 6.0,
      ),
      child: new Container(
      decoration: BoxDecoration(
      color:  Colors.black.withOpacity(0.7),
      ),)),
      new Scaffold(
          drawer: new Drawer(child: new Container(),),
          backgroundColor: Colors.transparent,
          body: new Center(
            child: new Column(
              children: <Widget>[
                new SizedBox(height: _height/12,),
                /*Container(
                  width: 200,
                  height: 200,
                  child:Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(icon: Icon(Icons.photo_library), onPressed: () => uploadImage(1)),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(icon: Icon(Icons.camera_alt), onPressed: () => uploadImage(0)),
                    ),
                    Center(child: new CircleAvatar(radius:_width<_height? _width/4:_height/4,backgroundImage: NetworkImage(widget.auth.currentUser.photoURL))
                    ),
                  ],
                )),*/
                new CircleAvatar(radius:_width<_height? _width/4:_height/4,backgroundImage: NetworkImage(widget.auth.currentUser.photoURL)),
                new ButtonTheme.bar(
                  child: new ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new IconButton(icon: Icon(Icons.camera_alt), onPressed: () => uploadImage(0)),
                    new IconButton(icon: Icon(Icons.photo_library), onPressed: () => uploadImage(1)),
                  ],
                ),
                ),
                new SizedBox(height: _height/80.0,),
                new Text(widget.auth.currentUser.displayName, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: _width/15, color: Colors.white),),
                new Padding(padding: new EdgeInsets.only(top: _height/30, left: _width/8, right: _width/8),
                  child:new Text('Snowboarder, Superhero and writer.\nSometime I work at google as Executive Chairman ',
                    style: new TextStyle(fontWeight: FontWeight.normal, fontSize: _width/25,color: Colors.white),textAlign: TextAlign.center,) ,),
                
              ],
            ),
          )
      )
    ],);
  }
}
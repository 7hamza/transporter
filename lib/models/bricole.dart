import 'package:cloud_firestore/cloud_firestore.dart';

class BricoleModel {
  String bricoleId;
  String description;
  bool available;
  GeoPoint bricoleLocation;
  String bricoleimgURL;

  BricoleModel({
    this.bricoleId,
    this.description,
    this.available,
    this.bricoleLocation,
    this.bricoleimgURL,
    });

  BricoleModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    bricoleId = documentSnapshot.id;
    description = documentSnapshot.data()['description'] as String;
    available = documentSnapshot.data()['available'] as bool;
    bricoleLocation = documentSnapshot.data()['location'] as GeoPoint;
    bricoleimgURL = documentSnapshot.data()['bricoleimgURL'] as String;
    
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class BricoleModel {
  String bricoleId;
  String description;
  bool available;
  GeoPoint bricoleLocation;

  BricoleModel({
    this.bricoleId,
    this.description,
    this.available,
    this.bricoleLocation,
    });

  BricoleModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    bricoleId = documentSnapshot.id;
    description = documentSnapshot.data()['description'] as String;
    available = documentSnapshot.data()['available'] as bool;
    bricoleLocation = documentSnapshot.data()['location'] as GeoPoint;
  }
}
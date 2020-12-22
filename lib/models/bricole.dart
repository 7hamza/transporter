import 'package:cloud_firestore/cloud_firestore.dart';

class BricoleModel {
  String bricoleId;
  String description;
  bool available;

  BricoleModel({
    this.bricoleId,
    this.description,
    this.available,
    });

  BricoleModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    bricoleId = documentSnapshot.id;
    description = documentSnapshot.data()['description'] as String;
    available = documentSnapshot.data()['available'] as bool;
  }
}
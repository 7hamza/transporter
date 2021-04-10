import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transporter/models/bricole.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database {
  final FirebaseFirestore firestore;
  
  Database({this.firestore});
  Stream<List<BricoleModel>> streamBricoles({String uid}) {
    try {
      return firestore
          .collection("bricoles")
          .doc(uid)
          .collection("bricoles")
          .where("available", isEqualTo: false)
          .snapshots()
          .map((query) {
        final List<BricoleModel> retVal = <BricoleModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(BricoleModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }
  Stream<List<BricoleModel>> streamLocations({String uid}) {
    try {
      return firestore
          .collection("bricoles")
          .doc(uid)
          .collection("bricoles")
          .where("location", isNotEqualTo: null)
          .snapshots()
          .map((query) {
        final List<BricoleModel> retVal = <BricoleModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(BricoleModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> addBricole({String uid, String content, GeoPoint location, File imgfile}) async {
    final storage = FirebaseStorage.instance;
    
    var ref = firestore.collection("bricoles").doc(uid).collection("bricoles").doc();
    var snapshot = await storage.refFromURL('gs://transporter-67539.appspot.com/')
    .child('bricoles/'+ref.id)
    .putFile(imgfile);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    
    try {
      ref.set({
        "bricoleId": ref.id,
        "description": content,
        "available": false,
        "location": location,
        "bricoleimgURL": downloadUrl,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBricole({String uid, String bricoleId}) async {
    try {
      firestore
          .collection("bricoles")
          .doc(uid)
          .collection("bricoles")
          .doc(bricoleId)
          .update({
        "available": true,
      });
    } catch (e) {
      rethrow;
    }
  }

}
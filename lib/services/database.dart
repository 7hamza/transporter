import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transporter/models/bricole.dart';

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
  
  Future<void> addBricole({String uid, String content, GeoPoint location}) async {
    try {
      firestore.collection("bricoles").doc(uid).collection("bricoles").add({
        "description": content,
        "available": false,
        "location": location,
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
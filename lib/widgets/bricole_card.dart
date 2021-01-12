import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transporter/models/bricole.dart';
import 'package:transporter/services/database.dart';

class BricoleCard extends StatefulWidget {
  final BricoleModel bricole;
  final FirebaseFirestore firestore;
  final String uid;

  const BricoleCard({Key key, this.bricole, this.firestore, this.uid})
      : super(key: key);

  @override
  _BricoleCardState createState() => _BricoleCardState();
}

class _BricoleCardState extends State<BricoleCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.bricole.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.bricole.bricoleLocation.latitude.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.bricole.bricoleLocation.longitude.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Checkbox(
              value: widget.bricole.available,
              onChanged: (newValue) {
                setState(() {});
                Database(firestore: widget.firestore).updateBricole(
                  uid: widget.uid,
                  bricoleId: widget.bricole.bricoleId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
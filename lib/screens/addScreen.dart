import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transporter/services/database.dart';


class AddScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const AddScreen({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  //final TextEditingController _bricoleController = TextEditingController();
  final TextEditingController _bricoleController = TextEditingController();
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
                      IconButton(
                        key: const ValueKey("addButton"),
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (_bricoleController.text != "") {
                            setState(() {
                              Database(firestore: widget.firestore).addBricole(
                                  uid: widget.auth.currentUser.uid,
                                  content: _bricoleController.text);
                              _bricoleController.clear();
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ])
        )
      )
    );
  }
}
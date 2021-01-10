import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transporter/models/bricole.dart';
import 'package:transporter/services/database.dart';
import 'package:transporter/widgets/bricole_card.dart';


class ListScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const ListScreen({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
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
                "My Bricoles",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: Database(firestore: widget.firestore)
                      .streamBricoles(uid: widget.auth.currentUser.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<BricoleModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data.isEmpty) {
                        return const Center(
                          child: Text("You don't have any available Bricoles"),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return BricoleCard(
                            firestore: widget.firestore,
                            uid: widget.auth.currentUser.uid,
                            bricole: snapshot.data[index],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("loading..."),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
      ),
    )
    );
  }
}
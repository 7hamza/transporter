import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transporter/screens/analytics.dart';
import 'package:transporter/screens/listScreen.dart';
import 'package:transporter/screens/mapScreen.dart';
import 'package:transporter/screens/addScreen.dart';
import 'package:transporter/screens/profile.dart';
import 'package:transporter/services/auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const Home({Key key, this.auth, this.firestore}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  //screens
  final MapScreen tab0 = MapScreen();
  final AnalyticsScreen tab3 = AnalyticsScreen();
  final ProfileScreen tab4 = ProfileScreen();

  //State class
  int _page = 2;
  GlobalKey _bottomNavigationKey = GlobalKey();

  Widget pageChooser(int page) {
    switch (page) {
      case 0:
        return tab0;
      case 1:
        return ListScreen(auth: widget.auth, firestore: widget.firestore);
      case 2:
        return AddScreen(auth: widget.auth, firestore: widget.firestore);
      case 3:
        return tab3;
      case 4:
        return tab4;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bricole"),
        centerTitle: true,
        actions: [
          IconButton(
            key: const ValueKey("signOut"),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Auth(auth: widget.auth).signOut();
            },
          )
        ],
      ),
      body: pageChooser(_page),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.black,
        height: 55,
        index: 2,
        items: <Widget>[
          Icon(Icons.map, size: 30, color: Colors.black,),
          Icon(Icons.list, size: 30, color: Colors.black),
          Icon(Icons.add, size: 30, color: Colors.black),
          Icon(Icons.analytics, size: 30, color: Colors.black),
          Icon(Icons.supervised_user_circle, size: 30, color: Colors.black),

        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
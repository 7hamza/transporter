import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BricolePage extends StatelessWidget {
  final String userMail;
  BricolePage({Key key, this.tag, this.userMail}) : super(key: key);
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: <Widget>[
              Hero(
                tag: tag,
                child: Image.asset(
                  "lib/assets/photo.jpeg",
                  fit: BoxFit.fitWidth,
              )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Bricole Description",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(child: Text(tag)),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Bricole Poster",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(child: Text(userMail))

            ]
          )
        ))    
    );
  }
}
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  final UserCredential userCredential;

  const IntroScreen({
    Key key, this.userCredential,
  }) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}
class _IntroScreenState extends State<IntroScreen> {
  
  List<PageViewModel> getPages() {
    
    return [
      PageViewModel(
          title: "Bricoles",
          image: Image.asset("lib/assets/040-social-care.png"),
          body: "Welcome to Bricoles",
          footer: Text("Bricoles in your Palm"),
          decoration: const PageDecoration(
            pageColor: Colors.black,
            imagePadding: EdgeInsets.only(top: 100.0),
          )),
      PageViewModel(
        image: Image.asset("lib/assets/013-teamwork-1.png"),
        title: "Tell us more about you ",
        footer: Text("Your name or a nickname"),
        bodyWidget: TextField(
              decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter Pseudo Here',
            ),
            textAlign: TextAlign.center,
            onChanged: (value) {
              widget.userCredential.user.updateProfile(displayName: value);
              widget.userCredential.user.updateProfile(photoURL: "https://thispersondoesnotexist.com/image");
            }),
        decoration: const PageDecoration(
            pageColor: Colors.black,
            imagePadding: EdgeInsets.only(top: 100.0),
          )
      ),
      PageViewModel(
        image: Image.asset("lib/assets/045-handshake.png"),
        title: "You're all Set ",
        body: "People are waiting for your help with their bricoles",
        decoration: const PageDecoration(
            pageColor: Colors.black,
            imagePadding: EdgeInsets.only(top: 100.0),
        )
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.black,
        pages: getPages(),
        showNextButton: true,
        showSkipButton: false,
        skip: Text("Skip"),
        done: Text("Got it "),
        onDone: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
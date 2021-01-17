
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'logout.dart';
import 'dart:async';

import 'package:international_phone_input/international_phone_input.dart';
import 'package:transporter/screens/introScreen.dart';
import 'package:transporter/services/auth.dart';



class PhoneLogin extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const PhoneLogin({
    Key key,
    @required this.auth,
    @required this.firestore,
  }) : super(key: key);
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {

  String phoneNo, phoneIsoCode, smssent, verificationId;

  get verifiedSuccess => null;

  Future<void> verfiyPhone() async{
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
      this.verificationId = verId;
    };
  final PhoneCodeSent smsCodeSent= (String verId, [int forceCodeResent]) {
    this.verificationId = verId;
    smsCodeDialoge(context).then((value){
     print("Code Sent");
    });
  };
    final PhoneVerificationCompleted verifiedSuccess= (AuthCredential auth){};
    final PhoneVerificationFailed verifyFailed= (e){
      print('${e.message}');
    };
    await widget.auth.verifyPhoneNumber(
      phoneNumber: '+33'+phoneNo,
      timeout: const Duration(seconds: 5),
      verificationCompleted : verifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,

    );
  
  }
  Future<bool> smsCodeDialoge(BuildContext context){
    return showDialog(context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
      return new AlertDialog(
        title: Text('Enter OTP'),
        content: TextField(
          onChanged: (value){
            this.smssent = value;
          },
        ),
        contentPadding: EdgeInsets.all(10.0),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
                if(widget.auth.currentUser != null){
                }
                else{
                  Navigator.of(context).pop();
                  signIn(smssent);
                }
            },
            child: Text('done', 
            style:TextStyle(color: Colors.white) ,),
          ),
        ],

      );
    }
    );
  }
  Future<void> signIn(String smsCode) async{
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
       smsCode: smsCode,);

    final UserCredential authResult = await widget.auth.signInWithCredential(credential); 
    print(authResult.additionalUserInfo.isNewUser);
    if(authResult.additionalUserInfo.isNewUser){
      Navigator.of(context).
      push(
      MaterialPageRoute(builder: (_) => IntroScreen(userCredential: authResult,)));
    }
      
  }


  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
       phoneNo = number;
       phoneIsoCode = isoCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('PhoneNumber Login'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.all(50.0),
            child: TextField(
              keyboardType: TextInputType.phone,
              onChanged: (value){
                this.phoneNo= value;
              },
            ),
            /*child: InternationalPhoneInput(
              decoration: InputDecoration.collapsed(hintText: '000000000'),
              onPhoneNumberChange: onPhoneNumberChange, 
              initialPhoneNumber: phoneNo,
              initialSelection: phoneIsoCode,
              enabledCountries: ['+212', '+33'],
              showCountryCodes: false
            ),*/
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            onPressed: verfiyPhone,
            child: Text("verify",
            style: TextStyle(color: Colors.white),),
            elevation: 7.0,
            color: Colors.grey,
          )
        ],
      ),
      
    );
  }
}
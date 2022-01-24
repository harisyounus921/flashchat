import 'package:flutter/material.dart';
import 'package:menu/chatappConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatappChatappScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
      // upperBound: 100.0,
    );

    animation = ColorTween(begin: Color(0xFF3E2A74), end: Color(0xFF5F4ECF))
        .animate(controller);

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
final _auth =FirebaseAuth.instance;
bool showSpinner=false;
  String email;
  String name;
  String paswords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body:ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              Flexible(
                child: Hero(
                  tag: "hero",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              /*TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    name=value.trim();
                  },
                  decoration: ktextfeilddecoration.copyWith(
                    //   prefixText: "harisyounus921@gmail.com",
                      hintText: "Enter your name.")),
              SizedBox(
                height: 8.0,
              ),*/
              TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                 email=value.trim();
                  },
                  decoration: ktextfeilddecoration.copyWith(
                 //   prefixText: "harisyounus921@gmail.com",
                      hintText: "Enter your email.")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    paswords=value.trim();
                  },
                  decoration: ktextfeilddecoration.copyWith(
                   // prefixText: "12345678",
                      hintText: "Enter your password.")),
              SizedBox(
                height: 24.0,
              ),
              Buttons(
                title: "Register",
                color: Colors.blueAccent,
                onpress: ()async{
                  setState(() {
                    showSpinner=true;
                  });
                  try {
                    final newuser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: paswords);
                       // .then((value) async {
                      User user = FirebaseAuth.instance.currentUser;

                      await FirebaseFirestore.instance.collection("emails").doc(user.uid).set({
                        'email': email,
                        'password':paswords,
                    });
                    if(newuser!=null){
                      Navigator.pushNamed(context, HomeScreen.id,arguments: name);
                    }
                    setState(() {
                      showSpinner=false;
                    });
                  }
                  catch(e){
                    print(e);
                    showDialog(context: context, builder: (BuildContext content){
                      return AlertDialog(content:Text(e.message),);
                    });
                    }
                },
              ),
            ],
          ),
        ),
     ),
    );
  }
}

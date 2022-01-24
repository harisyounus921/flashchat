import 'package:flutter/material.dart';
import 'package:menu/chatappConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatappChatappScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

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
      body:  ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                TextFormField(
                    validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                            controller: TextEditingController(text: "harisyounus921@gmail.co"),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email=value.trim();
                            },
                            decoration: ktextfeilddecoration.copyWith(
                              //  hintText: "Enter your email"
                              )
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          obscureText: true,
                          validator: (val)
                          {
                            if (val.isEmpty)
                            {
                              return 'Please enter some text';
                            }
                            if (val.length < 3)
                            {
                              return 'Must be more than 2 charater';
                            }
                            return "thanks";
                          },
                          onChanged: (value) {
                                paswords=value.trim();
                          },
                          decoration: ktextfeilddecoration.copyWith(
                              hintText: "Enter your password."),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                Buttons(
                  title: "Log In",
                  color: Colors.lightBlueAccent,
                  onpress: () async{
                    setState(() {
                      showSpinner=true;
                    });
                    try{
                      final user=await _auth.signInWithEmailAndPassword(email: email, password: paswords);
                      if(user!=null)
                        {
                          Navigator.pushNamed(context, HomeScreen.id);
                        }
                      setState(() {
                        showSpinner=false;
                      });
                    }
                    catch(e)
                    {
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

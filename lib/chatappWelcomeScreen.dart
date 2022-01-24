import 'package:menu/chatappLoginScreen.dart';
import 'package:menu/chatappRegistrationScreen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:menu/chatappConstant.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: "hero",
                  child: Container(
                    child: Image.asset('assets/logo.png'),
                    height: 60.0,
                    //  height: controller.value,
                  ),
                ),
                WavyAnimatedTextKit(
                  //TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFBB03B)
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Buttons(
              title: "Log In",
              color: Colors.lightBlueAccent,
              onpress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            Buttons(
              title: "Register",
                color:Color(0xFFFBB03B),
              // color: Colors.blueAccent,
              onpress: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

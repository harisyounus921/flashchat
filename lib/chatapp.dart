import 'package:flutter/material.dart';
//import 'package:firebase/chatappConstant.dart';
import 'package:menu/chatappChatappScreen.dart';
import 'package:menu/chatappLoginScreen.dart';
import 'package:menu/chatappRegistrationScreen.dart';
import 'package:menu/chatappWelcomeScreen.dart';

import 'home_screen.dart';

//void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
      },
    );
  }
}

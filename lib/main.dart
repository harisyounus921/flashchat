import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:menu/chatappChatappScreen.dart';
import 'package:menu/chatappLoginScreen.dart';
import 'package:menu/chatappRegistrationScreen.dart';
import 'package:menu/chatappWelcomeScreen.dart';
import 'package:menu/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menu/setting.dart';
import 'package:menu/video.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chats_screen.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        SettingsScreen.id:(context)=>SettingsScreen(),
        VideoViewPage.id:(context)=>VideoViewPage(),
      },
    );
  }
}

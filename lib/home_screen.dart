import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:menu/chatappChatappScreen.dart';
import 'package:menu/groups.dart';
import 'package:menu/tab.dart';
import 'package:menu/status_screen.dart';
import 'package:menu/chats_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

User loggedInUser;
var activeTabTextStyle = TextStyle(
  fontSize: 16,
);
var inactiveTabTextStyle = TextStyle(
  fontSize: 13,
);
class HomeScreen extends StatefulWidget {
  static String id = "home_screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  TabController _tabController;
  int _currentTab = 1;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  final messageTextController=TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth =FirebaseAuth.instance;
  Stream messStream = FirebaseFirestore.instance.collection('messages').snapshots();
  String userMessage;
  String imagePath;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 1;

    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    print('Current index is $_currentTab');

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("  ⚡️Chatapp",style:TextStyle(fontSize: 33),
          ),
        actions: <Widget>[
          TextButton(
            onPressed: ()async {
              final ImagePicker _picker=ImagePicker();
              final image =await _picker.pickImage(source: ImageSource.gallery);
              setState(() {
                imagePath=image.path;
              });
              click();
              try{
                String imagename=basename(imagePath);
                firebase_storage.Reference ref =
                firebase_storage.FirebaseStorage.instance.ref('/$imagename');
                File file=File(imagePath);
                await ref.putFile(file);
                String downloadedurl=await ref.getDownloadURL();
                _firestore.collection('account').add({
                  'pic':downloadedurl,
                  'sender':loggedInUser.email,
                });
                setState(() {
                  flag=true;
                });
              }catch(e)
              {
                print(e.message);
              }
            },
            child: Icon(Icons.account_box_sharp, color: Colors.white,),
          ),
          IconButton(icon: Icon(Icons.logout),color: Colors.white, onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);}),
        ],
        bottom: TabBar(
          labelStyle: activeTabTextStyle,
          labelColor: Colors.black,
          unselectedLabelStyle: inactiveTabTextStyle,
          unselectedLabelColor: Colors.blueGrey,
          tabs: [
            TabWidget(label: "Stories", unreadCount: 1,),
            TabWidget(label: "Chats", unreadCount: 0,),
            TabWidget(label: "Groups", unreadCount: 0,),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(children: [
        StatusScreen(),
        //ChatsScreen(),
        HomeScreen1(),
        Whatsapp(),
      ],
        controller: _tabController,
      ),
      /*floatingActionButton: FloatingActionButton(onPressed: (){
        setState(() {

        });
      },
        foregroundColor: Colors.white,
        child: Icon(Icons.comment,),
      ),*/
     // bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      notchMargin: 6,
      elevation: 16,
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.photo_camera,
                  color: Colors.grey,
                ),
                Text("Add story",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
               // _showBottomSheet(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.menu,
                    color: Colors.grey,
                  ),
                  Text("Menu",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {

    _key.currentState.showBottomSheet((context) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person_pin, color: Colors.blueGrey,),
              title: Text("My Profile", style: TextStyle(color: Colors.blueGrey),),
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Colors.blueGrey,),
              title: Text("New Chat", style: TextStyle(color: Colors.blueGrey),),
            ),
            ListTile(
              leading: Icon(Icons.group, color: Colors.blueGrey,),
              title: Text("New Group Chat", style: TextStyle(color: Colors.blueGrey),),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.blueGrey,),
              title: Text("Starred Messages", style: TextStyle(color: Colors.blueGrey),),
            ),
          ],
        ),
      );
    });

  }



}

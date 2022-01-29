import 'package:firebase_storage/firebase_storage.dart';
import 'package:menu/Chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:menu/chatappConstant.dart';
import 'package:menu/chatappWelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'ZgroupChatRoom.dart';
import 'chatappChatappScreen.dart';
import 'example.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> with WidgetsBindingObserver {
  Map<String, dynamic> userMap;
  Map<String, dynamic> user;
  bool isLoading = false;
  bool showSpinner=false;

  final TextEditingController _search = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override

  String chatRoomId(String user1, String user2)
  {//user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]
    if (true)
    {
      return "$user1$user2";
    }
    else
    {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('messages')
        .where("sender", isGreaterThanOrEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });

    await _firestore
        .collection('account')
        .where("text")
        .get()
        .then((value) {
      setState(() {
        user = value.docs[0].data();
      });
      print(user);
    });

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: SingleChildScrollView(
          child: isLoading
              ? Center(
            child: Container(
              height: size.height / 20,
              width: size.height / 20,
              child: CircularProgressIndicator(),
            ),
      )
              : Column(
            children: [
              SizedBox(
                height: size.height / 20,
              ),
              Container(
                height: size.height / 14,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height / 14,
                  width: size.width / 1.15,
                  child: TextField(
                    controller: _search,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    decoration: ktextfeilddecoration.copyWith(
                        hintText: "Search by Name"
                    )
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              Buttons(
                title: "Search",
                color: Colors.lightBlueAccent,
                onpress: onSearch,
              ),
             // ElevatedButton(onPressed: onSearch, child: Text("Search"),),
              SizedBox(
                height: size.height / 50,
              ),
              Divider(
                color: Colors.black,
              ),
              userMap != null
                  ? ListTile(
                onTap: ()
                {
                  String roomId = chatRoomId(_auth.currentUser.displayName, userMap['name']);

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => Chat(
                        chatRoomId: roomId,
                        userMap: userMap,
                      ),
                    ),
                  );
                },
               // leading: CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/me.jpg')),
                leading: CircleAvatar(radius: 30, backgroundImage: AssetImage("assets/me.jpg")),
                title: Text(
                  userMap['sender'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(userMap['sender']),
                trailing: Icon(Icons.message, color: Colors.black),
              )
                  : Container(),
            ],
      ),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(),
          ),
        ),
      ),
    );
  }
}

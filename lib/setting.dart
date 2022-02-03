import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:menu/ststus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menu/chatappChatappScreen.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'chatappConstant.dart';

class SettingsScreen extends StatefulWidget {
  static String id = "setting_screen";
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool alockInBackground = true;
  bool blockInBackground = false;
  bool clockInBackground = true;
  bool dlockInBackground = false;
  bool notificationsEnabled =false;
  String imagePath;

  void pickimage()async{
    final ImagePicker _picker=ImagePicker();
    final image =await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath=image.path;
    });
    try{
      String imagename=basename(imagePath);

      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref('/$imagename');

      File file=File(imagePath);
      await ref.putFile(file);
      String downloadedurl=await ref.getDownloadURL();
      FirebaseFirestore db=FirebaseFirestore.instance;
      User user = FirebaseAuth.instance.currentUser;
      Map<String, dynamic> newpost = {
        'picture':downloadedurl,
      };
      await db.collection("account").doc(user.uid).update(newpost);
    }catch(e)
    {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text('⚡  Settings ')),
      body: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Stack(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('account').snapshots(),
                builder: ( context, snapshot)
                {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  if (!snapshot.hasData) {
                    return Text("Loading data please wait!");
                  }
                  return Column(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map data = document.data();
                      String id=document.id;
                      data["id"]=id;
                      return (data["id"]==FirebaseAuth.instance.currentUser.uid)?
                       CircleAvatar(radius: 75, backgroundImage: NetworkImage("${data["picture"]}"),
                          backgroundColor: Colors.transparent,)
                      : Container();
                    }).toList(),
                  );
                },
              ),
              Positioned(
                top: 90,
                left:85,
                child:   TextButton(onPressed: pickimage,
                   child: Icon(Icons.account_circle_rounded, color: Colors.black87,size: 45,),
          ),
                ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          //Buttons(title: "UPLOAD", color: Colors.lightBlueAccent, onpress: pickimage,),
          Text(FirebaseAuth.instance.currentUser.email,  style: TextStyle(
            fontSize: 22.0,
            color: Colors.lightBlueAccent,
          ),),
          SizedBox(
            height: 20.0,
          ),
          Expanded(child: buildSettingsList()),
         /* Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: postStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                {
                  return ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map data = document.data();
                      String id=document.id;
                      data["id"]=id;
                      return stauses(data:data,);
                    }).toList(),
                  );
                },
              ),
            ),*/
        ],
      ),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Account',style: TextStyle(
            fontSize: 18.0,
            color: Colors.lightBlueAccent,
          ),),
          tiles: [
            SettingsTile(title: Text('Phone number'), leading: Icon(Icons.phone)),
           // SettingsTile(title: Text('Email'), leading: Icon(Icons.email)),
            SettingsTile(title: Text('Sign out'), leading: Icon(Icons.exit_to_app),   onPressed: (context) {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },),
          ],
        ),
        SettingsSection(
          title: Text('Security',style: TextStyle(
            fontSize: 18.0,
            color: Colors.lightBlueAccent,
          ),),
          tiles: [
            SettingsTile.switchTile(
              title: Text('Lock app in background',),
              leading: Icon(Icons.phonelink_lock,),
              initialValue: alockInBackground,
              onToggle: (bool value) {
                setState(() {
                  alockInBackground = value;
                  notificationsEnabled = value;
                });
              },
            ),
            SettingsTile.switchTile(
              title: Text('Use fingerprint'),
              description: Text('Allow application to access stored fingerprint IDs.'),
              leading: Icon(Icons.fingerprint),
              initialValue: blockInBackground,
              onToggle: (bool value) {
                setState(() {
                  blockInBackground = value;
                });
              },
            ),
            /*SettingsTile.switchTile(
              title: Text('Enable Notifications'),
              enabled: notificationsEnabled,
              leading: Icon(Icons.notifications_active),
              initialValue:dlockInBackground,
              onToggle: (value) {
                setState(() {
                  dlockInBackground = value;
                  notificationsEnabled = value;
                });
              },
            ),*/
          ],
        ),
      ],
    );
  }
}



class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Languages')),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: Text("English"),
              trailing: trailingWidget(0),
              onPressed: (BuildContext context) {
                changeLanguage(0);
              },
            ),
            SettingsTile(
              title: Text("Spanish"),
              trailing: trailingWidget(1),
              onPressed: (BuildContext context) {
                changeLanguage(1);
              },
            ),
            SettingsTile(
              title: Text("Chinese"),
              trailing: trailingWidget(2),
              onPressed: (BuildContext context) {
                changeLanguage(2);
              },
            ),
            SettingsTile(
              title: Text("German"),
              trailing: trailingWidget(3),
              onPressed: (BuildContext context) {
                changeLanguage(3);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check_box, color: Colors.blue)
        : Icon(Icons.check_box_outline_blank, color: Colors.blue);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
  }
}


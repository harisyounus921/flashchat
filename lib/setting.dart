import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          CircleAvatar(radius: 75, backgroundImage: AssetImage("assets/me.jpg")),
          SizedBox(
            height: 20.0,
          ),
          Text("data",  style: TextStyle(
            fontSize: 22.0,
            color: Colors.lightBlueAccent,
          ),),
          Expanded(child: buildSettingsList()),
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


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menu/chatappConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:menu/ststus.dart';
import 'package:path/path.dart';
import 'dart:io';

User loggedInUser;
bool flag=false;

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth =FirebaseAuth.instance;
  Stream messStream = FirebaseFirestore.instance.collection('messages').snapshots();
  String userMessage;
  String imagePath;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser()async{
    try {
      final user =await _auth.currentUser;
            if (user != null)
            {
                   loggedInUser = user;
             }
    }
    catch(e)
    {
print(e);
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: null,
        actions: [
          IconButton(icon: Icon(Icons.logout),color: Colors.white, onPressed: () {
            _auth.signOut();
          Navigator.of(context).popUntil((route) => route.isFirst);}),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.more_vert
                ),
              )
          ),
        ],
        title: Text('⚡️Family Time'),
      ),
      body: SafeArea(
        child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              MessagesStream(),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 18, top: 12),
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(56), end: Radius.circular(56)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            userMessage=value;
                          },
                          decoration: InputDecoration(
                              hintText: 'Type your message',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              )
                          ),
                        ),
                      ),
                    ),
                   /* IconButton(icon: Icon(EvaIcons.close), color: Colors.white,
                        onPressed: () {   messageTextController.clear();}),
                    TextButton(
                      onPressed: () {
                        messageTextController.clear();
                      },
                      child: CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.lightBlueAccent,
                        child: Icon(EvaIcons.close, color: Colors.white,),
                      ),
                    ),*/
                    TextButton(
                      onPressed: ()async {
                        final ImagePicker _picker=ImagePicker();
                        final camera =await _picker.pickImage(source: ImageSource.camera);
                        setState(() {
                          imagePath=camera.path;
                        });
                        try{
                          String imagename=basename(imagePath);
                          firebase_storage.Reference ref =
                          firebase_storage.FirebaseStorage.instance.ref('/$imagename');
                          File file=File(imagePath);
                          await ref.putFile(file);
                          String downloadedurl=await ref.getDownloadURL();
                          _firestore.collection('messages').add({
                            'text':downloadedurl,
                            'sender':loggedInUser.email,
                            'name':loggedInUser.email,
                            'type':"pic",
                            "time":DateFormat('hh:mm a').format(DateTime.now()),
                          });
                          setState(() {
                            flag=true;
                          });
                        }catch(e)
                        {
                          print(e.message);
                        }
                      },
                       /// if(flag)?
                       //child:  Icon(Icons.add, color: Colors.white,):
                       child: Icon(Icons.camera, color: Colors.white,),
                    ),
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
                          _firestore.collection('messages').add({
                            'text':downloadedurl,
                            'sender':loggedInUser.email,
                            'name':loggedInUser.email,
                            'type':"pic",
                            "time": DateFormat('kk:mm a').format(DateTime.now()),
                          });
                          setState(() {
                            flag=true;
                          });
                        }catch(e)
                        {
                          print(e.message);
                        }
                      },
                        child: Icon(Icons.image, color: Colors.white,),
                    ),
                    TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        if(userMessage!=null)
                        _firestore.collection('messages')//.orderBy()
                            .add({
                          'text':userMessage,
                          'sender':loggedInUser.email,
                          'name':loggedInUser.email,
                          'type':"text",
                          "time":DateFormat('hh:mm a').format(DateTime.now()),
                        });
                        setState(() {
                          userMessage=null;
                        });
                      },
                      child: CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.lightBlueAccent,
                        child: Icon(Icons.send, color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
     // ),
    );
  }
}


class click extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: (){}, child: Text("DOWN")),
          ],
        ),
      ),
    );
  }
}



class MessageBubble extends StatelessWidget {
  MessageBubble({@required this.time,this.type,this.sender, this.text, this.isMe});
  final String time;
  final String sender;
  final String text;
  final String type;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child:
            Column(
              children: [
                (type=="pic")?
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child:Image.network(text, width:150, height:170),):
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(text, style: TextStyle(
                        color: isMe ? Colors.white : Colors.black54, fontSize: 17.0,),),
            ),
                Text(time, style: TextStyle(
                  color: Colors.black, fontSize: 15.0,),),
                //Timestamp(time),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return   StreamBuilder<QuerySnapshot>(
      stream:  FirebaseFirestore.instance.collection('messages').snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData)
        {
          return Center(child:CircularProgressIndicator
            (
            backgroundColor: Colors.lightBlueAccent,
          ),);
        }
        final messages=snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles=[];
        for(var message in messages){
          print(message);
          final messageText=message.get("text");
          final messageSender=message.get('sender');
          final currentUser=loggedInUser.email;
          final messageType=message.get('type');
          final tim=message.get('time');
           final messageBubble=MessageBubble(time: tim,type:messageType,sender: messageSender,text: messageText,isMe:currentUser==messageSender,);
          messageBubbles.add(messageBubble);
        }
        return Expanded(child: ListView(
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          children: messageBubbles,));
      }
  );
}
}


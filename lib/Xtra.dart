import 'dart:io';
import 'package:flutter/material.dart';
import 'package:menu/ststus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:menu/chatappConstant.dart';

User loggedInUser;
int likes =0;
int dislikes=0;
dynamic Idnumber;

class StatusScreen extends StatefulWidget {
  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {

  TextEditingController titlecontroler=TextEditingController();
  TextEditingController descriptioncontroler=TextEditingController();
  String imagePath;
  bool value=false;
  Stream postStream = FirebaseFirestore.instance.collection('post').snapshots();
  final _auth =FirebaseAuth.instance;

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

    void pickimage()async{
      final ImagePicker _picker=ImagePicker();
      final image =await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imagePath=image.path;
      });
    }

    void submit() async{
      try{
        String title=titlecontroler.text;
        String description=descriptioncontroler.text;
        String imagename=basename(imagePath);

        firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('/$imagename');

        File file=File(imagePath);
        await ref.putFile(file);
        String downloadedurl=await ref.getDownloadURL();
        FirebaseFirestore db=FirebaseFirestore.instance;

        await db.collection("post").add({
          "title":title,
          "description":description,
          'name': loggedInUser.email,
          "url":downloadedurl,
          "id":Idnumber,
          "like":likes,
          'dislike':dislikes,
          'ystatus':"no",
          'nstatus':"no",
        });

        await db.collection("allpost").add({
          "title":title,
          "description":description,
          'name': loggedInUser.email,
          "url":downloadedurl,
          "id":Idnumber,
          "like":likes,
          'dislike':dislikes,
          'nstatus':"no",
          'ystatus':"no",
        });

        titlecontroler.clear();
        descriptioncontroler.clear();
        setState(() {
          value=false;
        });
      }catch(e)
      {
        print(e.message);
      }
    }
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
            child:Column(
              children: [
                Visibility(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: titlecontroler,
                        decoration:  ktextfeilddecoration.copyWith(
                            hintText: "Enter your Title."),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                          controller: descriptioncontroler,
                          decoration: ktextfeilddecoration.copyWith(
                              hintText: "Enter Description.")
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: pickimage, style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                            padding: MaterialStateProperty.all(EdgeInsets.all(13)),
                          ),child: Icon(Icons.image)),
                          Buttons(
                            title: "UPLOAD",
                            color: Colors.lightBlueAccent,
                            // child: Icon(Icons.image),
                            onpress: submit,
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                    ],
                  ),
                  visible: value,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: postStream,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                      {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        return ListView(
                          children: snapshot.data.docs.map((DocumentSnapshot document) {
                            Map data = document.data();
                            String id=document.id;
                            Idnumber=id;
                            data["id"]=id;
                            return stauses(data:data,);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),],
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: (){
          setState(() {
            value=true;
          });
        },
        foregroundColor: Colors.white,
        child: Icon(Icons.image),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class Editdialog extends StatefulWidget {
  Map data;
  Editdialog({this.data});
  @override
  State<Editdialog> createState() => _EditdialogState();
}

class _EditdialogState extends State<Editdialog> {
  String imagePath;
  TextEditingController titlecontroler=TextEditingController();
  TextEditingController descriptioncontroler=TextEditingController();

  @override
  void initState(){
      super.initState();
      titlecontroler.text=widget.data["title"];
      descriptioncontroler.text=widget.data["description"];
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

    void donepost()async {
      try {
        String imagename=basename(imagePath);

        firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('/$imagename');

        File file=File(imagePath);
        await ref.putFile(file);
        String downloadedurl=await ref.getDownloadURL();
        FirebaseFirestore db=FirebaseFirestore.instance;

        Map<String,dynamic> newpost={
          "title":titlecontroler.text,
          "description":descriptioncontroler.text,
          "url":downloadedurl
        };
        await db.collection("post").doc(widget.data["id"]).set(newpost);
        Navigator.of(context).pop();
      }
      catch (e) {
        print(e.message);
      }
    }
    return AlertDialog(
        content: Container(
     child: Column(
       mainAxisSize: MainAxisSize.min,
      children: [
       TextFormField(
       controller: titlecontroler,
       decoration: InputDecoration(labelText: 'Enter Title'),
     ),
          TextFormField(
            controller: descriptioncontroler,
            decoration: InputDecoration(labelText: 'Enter Description'),
          ),
          ElevatedButton(onPressed: pickimage, child: Text("PICK AN IMAGE")),
        ElevatedButton(onPressed: donepost, child: Text("DOWN")),
      ],
    ),
        ),
    );
  }
}

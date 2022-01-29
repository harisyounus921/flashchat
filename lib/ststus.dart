import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menu/statusEditdesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:like_button/like_button.dart';
import 'package:menu/status_screen.dart';

User loggedInUser;

dynamic DLSign=Icon(Icons.thumb_down_alt_outlined,color: Colors.blueAccent,);
dynamic LSign=Icon(Icons.thumb_up_alt_outlined,color: Colors.blueAccent,);

class stauses extends StatefulWidget {
  final Map data;
  stauses({this.data });
  @override
  State<stauses> createState() => _stausesState();
}
class _stausesState extends State<stauses> {

  void initState() {
    super.initState();
  }

  final _auth =FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {

    void deletepost(){
      try{
        FirebaseFirestore db=FirebaseFirestore.instance;
        db.collection("post").doc(widget.data["id"]).delete();
      }
      catch(e){
        print(e.message);
      }
    }
    void editpost(){
      showDialog(context: context, builder: (BuildContext context){
        return Editdialog(data: widget.data);
      });
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black,width: 1)
      ),
      padding:const EdgeInsets.all(10) ,
      child: Column(
        children: [
          Image.network(widget.data["url"],
              width:370,
              height:470),
          SizedBox(
            height: 24.0,
          ),
          Text(widget.data["name"],style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 20.0,
            color:Colors.blueAccent,
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton(
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child:LSign,// LikeButton(),
                    ),
                    onPressed: ()async{
                      setState(() {
                        LSign= Icon(Icons.thumb_up,color: Colors.blueAccent,);//LikeButton();
                      });
                     // if(widget.data["ystatus"]=="no")
                              {
                        Map<String, dynamic> newpost = {
                          "like": FieldValue.increment(1),
                          "ystatus":"yes",
                          //   widget.data["like"]:FieldValue.increment(1),
                        };
                        await FirebaseFirestore.instance.collection("post").doc(
                            widget.data["id"])
                            .update(newpost);
                      }
                    },
                  ),
                  Text(widget.data["like"].toString(),style: TextStyle(//description
                    fontSize: 20.0,
                    color: Colors.black,
                  )),
                ],
              ),
              Text(widget.data["title"],style: TextStyle(
                fontSize: 25.0,
                color: Colors.blueAccent,
              ),),
              Row(
                children: [
                  TextButton(
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: DLSign,
                    ),
                    onPressed: ()async{
                      setState(() {
                        DLSign=Icon(Icons.thumb_down,color: Colors.blueAccent,);
                      });
                     // if(widget.data["nstatus"]=="no")
                      {
                        Map<String, dynamic> newpost = {
                          "dislike": FieldValue.increment(1),
                          "nstatus":"yes"
                        };
                        await FirebaseFirestore.instance.collection("post").doc(
                            widget.data["id"])
                            .update(newpost);
                      }
                    },
                  ),
                  Text(widget.data['dislike'].toString(),style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  )
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(widget.data["name"]==_auth.currentUser.email)
              TextButton(
                onPressed: editpost,
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit,color: Colors.blueAccent,),
                ),
              ),
              Center(
                child: Text(widget.data["description"],style: TextStyle(//description
                  fontSize: 15.0,
                  color: Colors.black87,
                ),),
              ),
              if(_auth.currentUser.email==widget.data["name"])
              TextButton(
                onPressed: deletepost,
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.delete,color: Colors.blueAccent,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

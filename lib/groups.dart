import 'package:flutter/material.dart';
import 'chatappChatappScreen.dart';

class Whatsapp extends StatefulWidget {
 // static String id = "login_screen";
  @override
  _WhatsappState createState() => _WhatsappState();
}
class _WhatsappState extends State<Whatsapp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextButton(onPressed: (){
              setState(()              // Navigator.pushNamed(context, ChatScreen.id);
              {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));});
            }, child: whatsapp('assets/me.jpg', "Family Time", "Always", "4;00 pm", 5),
            ),
            Divider(
              color: Colors.black,
            ),
            TextButton(onPressed: (){
              setState(()              // Navigator.pushNamed(context, ChatScreen.id);
              {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));});
            }, child: whatsapp('assets/bg.png', "Family Time", "Always", "3;00 pm", 0),
            ),
            Divider(
              color: Colors.black,
            ),
            TextButton(onPressed: (){
              setState(()              // Navigator.pushNamed(context, ChatScreen.id);
              {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));});
            }, child: whatsapp('assets/me.jpg', "Family Time", "Always", "2;00 pm", 4),
            ),
            Divider(
              color: Colors.black,
            ),
            TextButton(onPressed: (){
              setState(()              // Navigator.pushNamed(context, ChatScreen.id);
              {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));});
            }, child: whatsapp('assets/bg.png', "Family Time", "Always", "1;00 pm", 0),
            ),
            Divider(
              color: Colors.black,
            ),
            TextButton(onPressed: (){
              setState(()              // Navigator.pushNamed(context, ChatScreen.id);
              {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));});
            }, child: whatsapp('assets/me.jpg', "Family Time", "Always", "12;00 pm", 2),
            ),
            Divider(
              color: Colors.black,
            ),
            TextButton(onPressed: (){
              setState(()              // Navigator.pushNamed(context, ChatScreen.id);
              {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));});
            }, child: whatsapp('assets/bg.png', "Family Time", "Always", "11;00 am", 1),
            ),
            Divider(
              color: Colors.black,
            ),
            TextButton(onPressed: (){
              setState(()              // Navigator.pushNamed(context, ChatScreen.id);
              {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));});
            }, child: whatsapp('assets/me.jpg', "Family Time", "Always", "10;00 am", 0),
            ),
            Divider(
              color: Colors.black,
            ),
            TextButton(onPressed: (){
              setState(()              // Navigator.pushNamed(context, ChatScreen.id);
              {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));});
            }, child: whatsapp('assets/bg.png', "Family Time", "Always", "11;00 am", 1),
            ),
            Divider(
              color: Colors.black,
            ),
            TextButton(onPressed: (){
              setState(()              // Navigator.pushNamed(context, ChatScreen.id);
              {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));});
            }, child: whatsapp('assets/me.jpg', "Family Time", "Always", "10;00 am", 0),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

Widget whatsapp(var pic, var name, var status, var time, var message) {
  return  ListTile(
    leading: CircleAvatar(radius: 40, backgroundImage: AssetImage(pic)),
    title: Text(name),
    subtitle: Text(status),
    trailing:
    Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Text(time),
      if(message!=0)
        CircleAvatar(backgroundColor: Colors.red, radius: 10, child:Text(message.toString()),)
    ]),
  );

}

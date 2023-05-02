

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import "package:uuid/uuid.dart";

final _firestore = FirebaseFirestore.instance;

class MessagingScreen extends StatefulWidget {

  final String chatRoomID;
  MessagingScreen({super.key,required this.chatRoomID, });

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {

  final messageTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    messageTextController.dispose();


  }
  addConversationMessages(String chatRoomID,messageMap){
    _firestore.collection("chatRoom").doc(chatRoomID).collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }
  File? imageFile;
  Future getImageFromGallery(String sender, String chatRoomID)async{
    ImagePicker _picker =ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile){
      if(xFile!=null){
        imageFile= File(xFile.path);
        uploadImage(sender,chatRoomID);
      }
    });


  }
  Future getImageFromCamera(String sender, String chatRoomID)async{
    ImagePicker _picker =ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((xFile){
      if(xFile!=null){
        imageFile= File(xFile.path);
        uploadImage(sender,chatRoomID);
      }
    });


  }
  Future uploadImage(String sender, String chatRoomID) async{
    String fileName=  Uuid().v1();
    int status =1;
    await  _firestore.collection("chatRoom").doc(chatRoomID).collection("chats").doc(fileName).set({
      "message":"",
      "sendBy" :sender,
      "type":"img",
      "time" :FieldValue.serverTimestamp(),
    });
    var ref= FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
    var uploadTask=await ref.putFile(imageFile!).catchError((e) async {
      await  _firestore.collection("chatRoom").doc(chatRoomID).collection("chats").doc(fileName).delete();
      status=0;
    });
    if(status==1){
      String imageUrl =await uploadTask.ref.getDownloadURL();
      await  _firestore.collection("chatRoom").doc(chatRoomID).collection("chats").doc(fileName).update({
        "message":imageUrl,
      });
    }

    //print(imageUrl);
  }
  sendMessage(String sender){
    if(messageTextController.text.isNotEmpty) {
      Map <String, dynamic> messageMap = {
        "message": messageTextController.text,
        "sendBy" :sender,
        "type":"text",
        "time" :FieldValue.serverTimestamp(),
      };
      addConversationMessages(widget.chatRoomID,messageMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatMessageList(chatRoomID:widget.chatRoomID,),
          Divider(),
          Container(
            //alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: messageTextController,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(

                              borderSide: BorderSide(color: Colors.deepPurple)),
                          suffixIcon:IconButton(
                            onPressed: (){
                              getImageFromGallery(ap.uid, widget.chatRoomID,);
                            },
                            icon: Icon(Icons.photo, color: Colors.deepPurple,),
                          ) ,
                          prefixIcon:IconButton(
                            onPressed: (){
                              getImageFromCamera(ap.uid, widget.chatRoomID,);
                            },
                            icon: Icon(Icons.camera_alt, color: Colors.deepPurple,),
                          ) ,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          hintText: 'Type your message here...',

                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: (){
                        print("button pressed");
                        sendMessage(ap.uid);
                        messageTextController.clear();
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),

                  ],
                ),
              )
          ),

        ],
      ),

    );
  }
}
class ChatMessageList extends StatefulWidget {
  final String chatRoomID;

  ChatMessageList({super.key,required this.chatRoomID});
  @override
  _ChatMessageListState createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  ScrollController messagescrollctrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return StreamBuilder(
        stream: _firestore.collection("chatRoom").doc(widget.chatRoomID).collection("chats").orderBy("time",descending: true).snapshots(),
        builder: (context,snapshot){
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            messagescrollctrl.animateTo(
                messagescrollctrl.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          });
          return snapshot.hasData?Expanded(
            child: ListView.builder(
                reverse: true,
                controller: messagescrollctrl,
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                itemBuilder: (context,index){
                  return MessageTile (message:snapshot.data!.docs[index]["message"],sendByMe:snapshot.data!.docs[index]["sendBy"]==ap.uid, type: snapshot.data!.docs[index]["type"], time: snapshot.data?.docs[index]["time"],);
                }),
          ): Container();
        });
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String type;
  final Timestamp time;

  MessageTile({required this.message, required this.sendByMe, required this.type, required this.time});




  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    return type=="text"? Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 1,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 12 : 0),
      alignment: sendByMe ? Alignment.bottomRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 12, bottom: 12, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                Colors.deepPurple,
                Colors.deepPurple,

              ]
                  : [
                Colors.deepPurpleAccent,
                Colors.deepPurpleAccent,
              ],
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            Text(message,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    )),
            Text(" "+DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch).hour.toString()+":"+ DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch).minute.toString(),
              style: TextStyle(fontSize: 9, color: Colors.purpleAccent.shade100),

            ),
          ],
        ),
      ),
    ) : Container(
      height: size.height/2.5,
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),

      child: InkWell(
        onTap: ()=>
            Navigator.of(context).push(
                MaterialPageRoute(builder:(_)=>ShowImage(imageUrl:message ))
            )
        ,
        child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 70)
              : EdgeInsets.only(right: 70),
          height: size.height/2.5,
          width: size.width,
          child: ClipRRect(

            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),


            //alignment: Alignment.center,
            child: message!=""?Image.network(
              message,
              fit: BoxFit.fill,
              height: size.height/2.5,
              width: size.width/2,

            ):CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}

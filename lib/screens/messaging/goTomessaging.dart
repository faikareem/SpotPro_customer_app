import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotpro_customer/screens/messaging/messagingScreen.dart';

final _firestore = FirebaseFirestore.instance;

  createChatroom(String chatRoomID, chatRoomMap){
    _firestore.collection("chatRoom").doc(chatRoomID).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }
  createChatroomAndStartConversation(String username, String username2, context){
    if(username!=username2){
      List<String> users=[username,username2];
      String chatRoomID= getChatRoomID(username,username2);
      Map<String,dynamic> chatRoomMap={
        "users":users,
        "chatRoomID":chatRoomID
      };
      createChatroom(chatRoomID, chatRoomMap);
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: MessagingScreen(chatRoomID: chatRoomID),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.slideRight,
      );
    }
    else{
      print("cant send yourself messages");
    }
  }


getChatRoomID(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "${b}_$a";
  } else {
    return "${a}_$b";
  }
}
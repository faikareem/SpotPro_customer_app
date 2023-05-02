import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotpro_customer/screens/sc_profile.dart';
import '../model/user_model.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:spotpro_customer/screens/mainpage.dart';
import 'package:spotpro_customer/screens/home_screen.dart';
import 'package:spotpro_customer/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  // File? image;

  TextEditingController namectrl = TextEditingController();

  TextEditingController emailctrl = TextEditingController();
  //TextEditingController phonectrl = TextEditingController();
  DateTime schedule = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      final ap = Provider.of<AuthProvider>(context, listen: false);

      namectrl.text = ap.userModel.name;
      emailctrl.text = ap.userModel.email;
      // phonectrl.text=ap.userModel.phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final SPid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: Text("Edit profile"), backgroundColor: Colors.deepPurple),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                margin: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  Center(child:Text("Profile image")),

                      Text("Full Name"),
                      textFeld(
                        //  initial: ap.userModel.name,

                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: namectrl,
                      ),
                      Text("Email address"),
                      textFeld(
                        //  initial: ap.userModel.name,

                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailctrl,
                      ),

                      const SizedBox(height: 10),

                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                      text: "Save",
                      onPressed: () {
                        if ((namectrl.text == "") || (emailctrl.text == "")) {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                      title: const Text("Alert Dialog Box"),
                                      content: const Text(
                                          "Please fill all the fields"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            color: Colors.deepPurple,
                                            padding: const EdgeInsets.all(14),
                                            child: const Text(
                                              "okay",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ]));
                        } else
                          storeData();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Data saved successfully!")));
                      }),

                  //SizedBox(width:2),
                  CustomButton(
                      text: "Cancel",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SCProfile()));
                      }),
                ],
              )
            ],
          ),
        ));
  }

  Widget textFeld({
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
    // required String initial
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        // initialValue: initial,
        cursorColor: Colors.deepPurple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.deepPurple,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.deepPurple.shade50,
          filled: true,
        ),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    // urllist=Promoimages.
    //
    //  await firebaseFirestore
    //     .collection("providers").doc(ap.userModel.uid)
    //     .set({'downloadURL': promourls},SetOptions(merge: true)).then((value) => showSnackBar("Image Uploaded", Duration(seconds: 2)));
    UserModel userModel = UserModel(
      //promourl: [],

      name: namectrl.text.trim(),
      createdAt: "",
      phoneNumber: "",
      uid: "",
      email: emailctrl.text,
    );

    ap.saveUserDataToFirebase(
      context: context,
      // id: image!,

      userModel: userModel,
      onSuccess: () {
        ap.saveUserDataToSP().then(
              (value) => ap.setSignIn().then(
                    (value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SCProfile(),
                      ),
                      (route) => false,
                    ),
                  ),
            );
      },
    );
  }

  @override
  void dispose() {
    namectrl.dispose();
    emailctrl.dispose();

    super.dispose();
  }
}

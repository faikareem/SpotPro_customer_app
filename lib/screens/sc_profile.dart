import 'package:carousel_slider/carousel_slider.dart';
import 'package:cherry_toast/resources/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'SC_Editprofile.dart';
import 'package:intl/intl.dart';

class SCProfile extends StatefulWidget {
  //final String id;
  //const SCProfile({Key? key, required this.id}) : super(key: key);

  @override
  State<SCProfile> createState() => _SCProfileState();
}

class _SCProfileState extends State<SCProfile> {
  late bool forAndroid = true;
  late var providerprofile;
  final SCid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    TextEditingController namectrl = TextEditingController();
    TextEditingController locationctrl = TextEditingController();
    TextEditingController emailctrl = TextEditingController();
    TextEditingController phonectrl = TextEditingController();
    DateTime schedule = DateTime.now();

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(ap.userModel.createdAt) * 1000);

    return new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: [
              Colors.deepPurple,
              Colors.deepPurple.shade200,
            ], begin: Alignment.topCenter, end: Alignment.center)),
          ),
          new Scaffold(
            backgroundColor: Colors.transparent,
            body: new Container(
              child: new Stack(
                children: <Widget>[
                  new Align(
                    alignment: Alignment.center,
                    child: new Padding(
                      padding: new EdgeInsets.only(top: _height / 10),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Icon(
                            (Icons.account_circle),
                            size: 100,
                            color: Colors.white,
                            grade: _height,
                          ),
                          new SizedBox(
                            height: _height / 10,
                          ),
                          new Text(
                            ap.userModel.name,
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: _height / 2.2),
                    child: new Container(
                      color: Colors.white,
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(
                        top: _height / 2.6,
                        left: _width / 20,
                        right: _width / 20),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 2.0))
                              ]),
                          child: new Padding(
                            padding: new EdgeInsets.all(_width / 20),
                            child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  //headerChild('Requests',DateFormat("d MMM YYYY").format(dateTime)),
                                  headChild('Our #1 customer',Icons.verified ),
                                ]),
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(top: _height / 20),
                          child: new Column(
                            children: <Widget>[
                              infoChild(
                                  _width, Icons.email, ap.userModel.email),
                              infoChild(
                                  _width, Icons.call, ap.userModel.phoneNumber),
                              new Padding(
                                padding: new EdgeInsets.only(top: _height / 30),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Editprofile()),
                                        (route) => false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),

                                      shadowColor: Colors.deepPurple.shade600,
                                      backgroundColor:
                                          Colors.deepPurple.shade400),
                                  child: new Text(' Edit Profile',
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerChild(String header, String value) => new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(header),
          new SizedBox(
            height: 8.0,
          ),
          new Text(
            '$value',
            style: new TextStyle(
                fontSize: 14.0,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold),
          )
        ],
      ));
  Widget headChild(String header, IconData icon) => new Expanded(
      child: new Column(
        children: <Widget>[
          new Text(header),
          new SizedBox(
            height: 8.0,
          ),
          new Icon(
            icon,
            color: Colors.deepPurple.shade400,
            size: 18.0,
          ),
        ],
      ));

  Widget infoChild(double width, IconData icon, data) => new Padding(
        padding: new EdgeInsets.only(bottom: 8.0),
        child: new InkWell(
          child: new Row(
            children: <Widget>[
              new SizedBox(
                width: width / 10,
              ),
              new Icon(
                icon,
                color: Colors.deepPurple.shade400,
                size: 36.0,
              ),
              new SizedBox(
                width: width / 20,
              ),
              new Text(data)
            ],
          ),
        ),
      );
}

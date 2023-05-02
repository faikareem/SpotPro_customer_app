
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:spotpro_customer/screens/searchresults.dart';
import 'package:text_divider/text_divider.dart';
import 'components.dart';
import 'allcategories.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'locationpicker.dart';




final FirebaseAuth auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  @override
  final User? user = auth.currentUser;
  FocusNode _focusNode = FocusNode();

  Widget build(BuildContext context) {
    FocusNode myfocus = FocusNode();
    List<String> suggestions = ["Painter","Chef","Cleaning","AC Repair","Carpenter"];
    List<Widget> slideChildren = [
    GestureDetector(
      onTap: (){
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: const ResultsList(category: 'Painter'),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.slideRight,
        );
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 1,
          margin: EdgeInsets.symmetric(horizontal: 5),

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 1,
                  blurRadius: 10
              )
            ],
            image: DecorationImage(
              image: NetworkImage('https://www.startupguys.net/wp-content/uploads/2021/06/two-painters-1024x682.jpg'),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Chip(label: Text(
                    'Time for a decor change?',
                    style: TextStyle(

                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                    elevation: 2,
                    backgroundColor: Colors.purple.shade100,

                  )
                ],
              ),
              alignment: Alignment.bottomLeft,
              heightFactor: 10,
            ),
          )


      ),
    ),
      GestureDetector(
        onTap: (){
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: const ResultsList(category: 'Chef'),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.slideRight,
          );
        },
        child: Container(

            width: MediaQuery.of(context).size.width / 1,
            margin: EdgeInsets.symmetric(horizontal: 5),

            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 1,
                  blurRadius: 10
                )
              ],
              image: DecorationImage(
                image: NetworkImage('https://www.insureon.com/-/media/blog/posts/2022/blog_catering-license-requirements.jpg?h=370&iar=0&w=700&rev=6d97d1d1cf8f4b5d8c04a61ab55bdcd3'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
              child: Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Chip(label: Text(
                      'Bringing world cuisine to you',
                      style: TextStyle(

                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                      elevation: 2,
                      backgroundColor: Colors.purple.shade100,

                    )
                  ],
                ),
                alignment: Alignment.bottomLeft,
                heightFactor: 10,
              ),
            )

        ),
      ),

      Container(
          width: MediaQuery.of(context).size.width / 1,
          margin: EdgeInsets.symmetric(horizontal: 5),

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 1,
                  blurRadius: 10
              )
            ],
            image: DecorationImage(
              image: NetworkImage('https://img.freepik.com/free-vector/fashion-sale-shopping-template-vector-promotional-aesthetic-ad-banner_53876-111573.jpg'),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),



      ),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [

              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Image.network(
                  'https://img.freepik.com/free-photo/sofa-purple-living-room-with-copy-space_43614-946.jpg?w=826&t=st=1680046928~exp=1680047528~hmac=fa714c9e29ca7547111ea86b8f71b5f7fefb36efce9b0e50814a4722d40a4f49',
                  width: double.infinity,
                  height: 255,
                  fit: BoxFit.cover,
                ),
              ),

              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 200, 20, 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 27, 0, 0),
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 0.5, //New
                                blurRadius: 15.0,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    InkWell(
                                      onTap: () async {},
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 0, 2),

                                        child: TypeAheadField<String>(

                                          textFieldConfiguration: TextFieldConfiguration(
                                            focusNode: _focusNode,
                                            decoration: const InputDecoration(
                                              hintText: 'Search for services...',
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight: Radius.circular(4.0),
                                                ),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight: Radius.circular(4.0),
                                                ),
                                              ),
                                              errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight: Radius.circular(4.0),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                              UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight: Radius.circular(4.0),
                                                ),
                                              ),
                                            ),
                                          ),

                                          suggestionsCallback: (pattern) {
                                            if (pattern != null && pattern.length > 0) {
                                              return  suggestions.where((bit) => bit.toLowerCase().contains(pattern.toLowerCase()));
                                            } else {
                                              return [];
                                            }
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  title: Text(suggestion),
                                                ),
                                                Divider(),
                                              ],
                                            );
                                          },
                                          onSuggestionSelected: (suggestion) {

                                            PersistentNavBarNavigator.pushNewScreen(
                                              context,
                                              screen: ResultsList(category: suggestion),
                                              withNavBar: false, // OPTIONAL VALUE. True by default.
                                              pageTransitionAnimation: PageTransitionAnimation.slideRight,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          screen: LocationPickerScreen(),
                                          withNavBar: false, // OPTIONAL VALUE. True by default.
                                          pageTransitionAnimation: PageTransitionAnimation.slideRight,
                                        );
                                      },
                                      child: Icon(Icons.location_on),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 15) ,
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 0, 0, 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    autofocus: true,
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {

                      NotificationSettings S = await FirebaseMessaging.instance.requestPermission();
                      String? fcmToken = await FirebaseMessaging.instance.getToken();
                      print(fcmToken);
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: AllCategories(),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.slideRight,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){

                  },
                  child: Catcard(name: 'AC Repair', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Fair-conditioner%20(1).png?alt=media&token=71a927ab-0575-49e8-9fba-3a11d22d8904',),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){

                  },
                  child: Catcard(name: 'Painter', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Froller.png?alt=media&token=5c890a50-d9ef-4b0c-bfca-7d1f40b43309',),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){

                  },
                  child: Catcard(name: 'Carpenter', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Fcarpenter.png?alt=media&token=9f49536b-d92b-4f10-9722-04d0c06fd5fe',),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){

                  },
                  child: Catcard(name: 'Chef', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Ffork.png?alt=media&token=b18db1fc-bda0-4da1-9825-786750c77dbd',),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){

                  },
                  child: Catcard(name: 'Cleaning', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Fbroom.png?alt=media&token=e4479bb4-b80f-4d64-83bd-6e08053202a6',),
                ),
                SizedBox(width: 10,),
              ],

            ),
          ),
          SizedBox(height: 25,),
          TextDivider(
              text: Text('FOR YOU', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold), ),
              thickness: 1,

          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(height: 5,),
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 4,
              scrollPhysics: ScrollPhysics(),
              enableInfiniteScroll: true,
              enlargeCenterPage: true,
            ),
            items: slideChildren,
          ),
        ],
      ),
    );
  }

  void getlocation() async{

    final SCid = FirebaseAuth.instance.currentUser!.uid;
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    FirebaseFirestore.instance.collection('users').doc(SCid).update(
        {
          'latlon':{'latitude':position.latitude,'longitude':position.longitude},
        }
    );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('lat', position.latitude);
      print(position.longitude);
      prefs.setDouble('long', position.longitude);
      print('done');



  }
}
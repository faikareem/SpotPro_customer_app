import 'package:flutter/material.dart';
import 'components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'welcome_screen.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'allcategories.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

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

  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    TextEditingController searchtext = TextEditingController();
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


              Positioned.fill(
                top: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Catcard(name: 'AC Repair'),
                      Catcard(name: 'Painter'),
                      Catcard(name: 'Electrician'),
                      Catcard(name: 'Plumber'),
                      Catcard(name: 'Cleaning'),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 200, 20, 0),
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
                                        child: TextFormField(
                                          controller: searchtext,
                                          onFieldSubmitted: (_) async {
                                            print('press');
                                          },
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'Search for services...',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                              const BorderRadius.only(
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
                                              const BorderRadius.only(
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
                                              const BorderRadius.only(
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
                                              const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.location_on),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(10, 120, 10, 10),
                          child: Text(
                            ' ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Playfair Display',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
              padding: EdgeInsetsDirectional.fromSTEB(15, 0, 20, 0),
              alignment: Alignment.centerLeft,
              child: InkWell(
                child: Text(
                  'All Categories >>',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: AllCategories(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.slideRight,
                  );
                },
              )),
          Divider(
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(
            height: 15,
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 4,
              scrollPhysics: ScrollPhysics(),
              enableInfiniteScroll: true,
              enlargeCenterPage: false,
            ),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width / 1,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.grey.withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Align(
                      child: Text(
                        'Featured Service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      heightFactor: 10,
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
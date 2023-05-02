import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotpro_customer/screens/homepage.dart';
import 'package:text_divider/text_divider.dart';
import '../provider/firestore_operations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'sp_profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


late double mylat;
late double mylong;

class ResultsList extends StatefulWidget {
  final String category;

  const ResultsList({Key? key, required this.category}) : super(key: key);

  @override
  State<ResultsList> createState() => _ResultsListState();
}

class _ResultsListState extends State<ResultsList> {
  @override
  String name = "";
  String cat = '';
  final SCid = FirebaseAuth.instance.currentUser!.uid;
  late List<ProviderData> providers;
  late var ref;

  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context){
    final catname = widget.category;
    List<String> dropDown = <String>[ "By Hourly Rate"];
    var usersQuery = FirebaseFirestore.instance.collection('providers')
        .where("service", isEqualTo: catname)
        .orderBy("rate");
    print(usersQuery.snapshots());
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.purple,
            actions: [
              DropdownButton<String>(
                  underline: Container(),
                  icon: Icon(Icons.sort,color: Colors.white),
                  items: dropDown.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if(value == 'By Hourly Rate') {
                      setState(() {
                      usersQuery = FirebaseFirestore.instance.collection('providers')
                          .where("service", isEqualTo: catname)
                          .orderBy("rate");
                    });
                    }

                    if(value == 'By Rating') {
                      setState(() {
                      usersQuery = FirebaseFirestore.instance.collection('providers')
                          .where("service", isEqualTo: catname)
                          .orderBy("review.2", descending: true);
                    });
                    }
                  }),
            ],
            title: Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
            child:TextField(
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                  focusColor: Colors.white,
                  hoverColor: Colors.purple, fillColor: Colors.white,
                  iconColor: Colors.purple,
                  prefixIconColor: Colors.purple,
                  prefixIcon: Icon(Icons.search, color: Colors.purple,), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            )

        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: ref,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {

              return Column(
                children: [
                  SizedBox(height: 20,),
                  const TextDivider(text: Text('Providers Near You', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic), ),),
                  SizedBox(height: 20,),
                  Expanded(child: StreamBuilder<QuerySnapshot>(
                    stream: usersQuery.snapshots(),
                    builder: (context, snapshots) {

                      return (snapshots.connectionState == ConnectionState.waiting)
                          ? Center(
                        child: CircularProgressIndicator(),
                      )
                          : ListView.builder(
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {

                            final prefs = snapshot.data!;
                            mylat = prefs['latlon']['latitude']!;
                            mylong = prefs['latlon']['longitude']!;
                            var provider = snapshots.data!.docs[index].data() as Map<String, dynamic>;
                            bool available = provider['available']!;
                            bool verified = provider['verified']!;
                            if (name.isEmpty && available && verified ) {
                              
                              return ProviderListItem(
                                name: provider['name'],
                                description: provider['desc'],
                                rate: provider['rate'].toString(),
                                location: provider['location'],
                                phonenumber: provider['phoneNumber'],
                                service: provider['service'],
                                SPid: provider['uid'],
                                lat: provider['latlon']['latitude'],
                                long: provider['latlon']['longitude'],

                              );
                            }
                            if (provider['name']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()) && available && verified) {
                              return ProviderListItem(
                                name: provider['name'],
                                description: provider['desc'],
                                rate: provider['rate'],
                                location: provider['location'],
                                phonenumber: provider['phoneNumber'],
                                service: provider['service'],
                                SPid: provider['uid'],
                                lat: provider['latlon']['latitude'],
                                long: provider['latlon']['longitude'],

                              );
                            }
                            return Container();
                          });
                    },
                  ))
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
    );
  }

  void getLocation() async{
    ref = FirebaseFirestore.instance.collection('users').doc(SCid).get();
  }

}

class ProviderListItem extends StatelessWidget {
  ProviderListItem({
    Key? key,
    required this.name,
    required this.rate,
    required this.location,
    required this.description,
    required this.service,
    required this.phonenumber,
    required this.SPid,
    required this.lat,
    required this.long,

  }) : super(key: key);

  final String? name;
  final String? SPid;
  final String? location;
  final String? rate;
  final String? service;
  final String? description;
  final String? phonenumber;
  final double? lat;
  final double? long;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(

        elevation:4,
        surfaceTintColor: Colors.purple,
        shadowColor: Colors.deepPurple.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(

                flex: 1,
                child: Center(
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.people_alt, color: Colors.white, size: 35,),

                  ),
                )
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),

                              color: Colors.purple,
                            ),
                            child: Padding(padding: EdgeInsets.all(6),
                              child: Text('Rs. ${rate!}/hr', style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),),
                            )

                        )
                      ],
                    ),
                    const SizedBox(height: 9),

                    Text(
                      location!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 9),

                    Text(
                      '${(GeolocatorPlatform.instance.distanceBetween(mylat, mylong, lat!, long!)/1000 ).toStringAsFixed(1)} Kms from you',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: SpProfile(id: SPid!),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.slideRight,
        );
      },
    );
  }
}






import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:spotpro_customer/screens/form.dart';
import 'package:provider/provider.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';
import 'package:text_divider/text_divider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/firestore_operations.dart';
import 'package:cherry_toast/cherry_toast.dart' as cherry;
import 'package:intl/intl.dart';

class SpProfile extends StatefulWidget {
  final String id;
  const SpProfile({Key? key, required this.id}) : super(key: key);

  @override
  State<SpProfile> createState() => _SpProfileState();
}

class _SpProfileState extends State<SpProfile> {
  late bool forAndroid = true;
  late var providerprofile;
  final SCid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    GetProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final ap = Provider.of<AuthProvider>(context, listen: false);
    TextEditingController namectrl = TextEditingController();
    TextEditingController locationctrl = TextEditingController();
    TextEditingController descctrl = TextEditingController();
    TextEditingController dateController = TextEditingController();
    DateTime schedule = DateTime.now();
    int reviewCount = 0;

    return Scaffold(
      body: FutureBuilder<String>(
        future:
            GetProfileData(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          String? privacy = providerprofile['privacy'];
          if (snapshot.hasData) {

            String rating = (providerprofile['review']['1'] == 0)? "0.0" : (providerprofile['review']['2']/providerprofile['review']['1']).toStringAsFixed(1);
            children = <Widget>[
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      providerprofile["image"],
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      SizedBox(
                        height: 160,
                      ),

                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(6, 0, 6, 0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Chip(
                                backgroundColor: Colors.white.withOpacity(0.5),
                                label: Text(
                                  providerprofile["service"],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Padding(
                                        padding: const EdgeInsets.only(bottom: 7.0),
                                        child: Text(
                                          providerprofile["name"],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        )),
                                    subtitle: Text(
                                      "Rs " + providerprofile["rate"].toString() + "/hr",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.purple),
                                    ),
                                    minVerticalPadding: 2.0,
                                  ),
                                  Divider(),
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 0, 15, 10),
                                      child: Row(
                                        children: [
                                          Text('Rating',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54)),
                                          Wrap(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.purple,
                                                size: 18,
                                              ),
                                              Text(
                                                rating,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              // Text(ap.userModel.name),
              // Text(ap.userModel.phoneNumber),
              // Text(ap.userModel.email),
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Row(
                  children: [
                    Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    //IconButton(onPressed:(){}, icon: Icon(Icons.edit)),
                  ],
                ),
                subtitle: Text(
                  providerprofile["desc"],
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ListTile(
                title: Text(
                  'Available At',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  providerprofile["location"],
                  style: TextStyle(fontSize: 12),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 0.5, left: 15, right: 15),
                child: Divider(thickness: 1),
              ),

              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),

                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('reviews').where('SPid', isEqualTo: widget.id).orderBy('createdAt').snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      final reviews = snapshot.data!.docs;
                      List <Widget> reviewWidgets = [];
                      for (var review in reviews){
                        ListTile card = ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            tileColor: Color(0xFFC9C5C5).withOpacity(0.4),
                            leading: Icon(
                              Icons.person,
                              size: 50,
                            ),
                            title: Text(
                              review['SCname'],
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              review['text'],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            trailing: Wrap(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.deepPurple,
                                ),
                                Text(
                                  review['rating'].toString(),
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ));
                        reviewWidgets.add(card);

                      }

                        reviewCount = reviewWidgets.length;

                      return CarouselSlider(
                      options: CarouselOptions(

                      height: MediaQuery.of(context).size.height / 10,

          scrollPhysics: ScrollPhysics(),
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          ),
          items: reviewWidgets,
          ) ;
                    }
                    else {
                      return Container();
                    }
                  },
                )
              ),
              SizedBox(
                height: 2,
              ),
              TextDivider(
                text: Text('Images by ${providerprofile['name']}', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold), ),
                thickness: 1,

              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('providers').orderBy('createdAt').snapshots(),
                builder: (context,snapshot){
                  List? pics= providerprofile['downloadURL'];
                  if(pics!=null){

                    List <Widget> picsWidgets = [];
                    for (var pic in pics){
                      print(pic);
                      Container card = Container(
                          height:MediaQuery.of(context).size.width/2 ,
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
                              image: NetworkImage(pic.toString()),
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


                      );
                      picsWidgets.add(card);

                    }

                    int picsCount = picsWidgets.length;

                    return CarouselSlider(
                      options: CarouselOptions(

                        height: MediaQuery.of(context).size.height / 3,

                        scrollPhysics: ScrollPhysics(),
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                      ),
                      items: picsWidgets,
                    ) ;
                  }
                  else {
                    return Container();
                  }
                },
              ),

            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ],
                ),
              )
            ];
          }

          return Stack(
          children: [
          SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
          ),
          ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                child: FloatingActionButton.extended(

                  backgroundColor: Colors.purple,
                  elevation: 10,
                  splashColor: Colors.purple,
                  label: Text(
                    'Contact',
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  onPressed: () async {
                    if (privacy == null || (privacy != null && privacy == 'on request')){
                      final _formKey = GlobalKey<FormState>();
                      showDialog(
                          context: context,

                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Send A Message'),
                              content: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(

                                        validator: (value) {
                                          if(value == null || value.isEmpty){
                                            return 'Please Enter Some Text';
                                          }
                                        },
                                        controller: namectrl,
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                          icon: Icon(Icons.account_box),
                                        ),
                                        textCapitalization: TextCapitalization.sentences,
                                      ),
                                      TextFormField(
                                        controller: locationctrl,
                                        validator: (value) {
                                          if(value == null || value.isEmpty){
                                            return 'Please Enter Some Text';
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Locality',
                                          icon: Icon(Icons.location_on),
                                        ),
                                        textCapitalization: TextCapitalization.sentences,
                                      ),
                                      TextFormField(
                                        controller: descctrl,
                                        validator: (value) {
                                          if(value == null || value.isEmpty || value.length< 10){
                                            return 'Enter a longer description.';
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Work Description',
                                          icon: Icon(Icons.message ),

                                        ),
                                        maxLines: null,
                                        textCapitalization: TextCapitalization.sentences,
                                      ),
                                      TextField(

                                        controller: dateController, //editing controller of this TextField
                                        decoration: const InputDecoration(

                                            icon: Icon(Icons.calendar_today), //icon of text field
                                            labelText: "Enter Date" //label text of field
                                        ),
                                        readOnly: true,  // when true user cannot edit text
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(), //get today's date
                                              firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                              lastDate: DateTime(2101)
                                          );

                                          if(pickedDate != null ){
                                            schedule = pickedDate;
                                            //get the picked date in the format => 2022-07-04 00:00:00.000
                                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                            //formatted date output using intl package =>  2022-07-04
                                            //You can format date as per your need


                                            dateController.text = formattedDate; //set foratted date to TextField value.

                                          }else{
                                            print("Date is not selected");
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                MaterialButton(onPressed: () async {
                                  // Validate returns true if the form is valid, or false otherwise.

                                  if (_formKey.currentState!.validate()) {
                                    var ref = await FirebaseFirestore.instance.collection('users').doc(SCid).get();

                                    double mylat = ref.data()!['latlon']['latitude'];
                                    double mylong = ref.data()!['latlon']['longitude'];
                                    await addRequestData(
                                      SCid: SCid,
                                      SPid: widget.id,
                                      timestamp: Timestamp.now(),
                                      scheduled: schedule,
                                      name: namectrl.text,
                                      locality: locationctrl.text,
                                      workDescription: descctrl.text , status: 'sent',
                                      lat: mylat, long : mylong,
                                    );
                                    Navigator.of(context, rootNavigator: true).pop();
                                    cherry.CherryToast.success(
                                        title:  Text("Message has been sent.")
                                    ).show(context);
                                  }

                                  else print('error');
                                },
                                  child: Text("Send", style: TextStyle(color: Colors.white),),
                                  color: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                )
                              ],
                            );
                          });
                    }
                    else if (privacy != null && privacy == 'public'){

                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: providerprofile['phoneNumber'],
                      );
                      await launchUrl(launchUri);
                    }

                  },
                  icon: Icon(Icons.send_rounded),
                ),
              ),
            ),
          ],
          );
        },
      ),
    );
  }

  Future<String> GetProfileData() async {
    final String id = widget.id;
    var document =
        await FirebaseFirestore.instance.collection('providers').doc(id).get();
    providerprofile = document.data();
    return 'done';
  }
}

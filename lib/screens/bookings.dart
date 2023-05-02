import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:spotpro_customer/widgets/review.dart';
import 'package:text_divider/text_divider.dart';
import '../provider/firestore_operations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../screens/messaging/goTomessaging.dart';

class BookingList extends StatefulWidget {
  const BookingList({super.key});

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  @override

  final SCid = FirebaseAuth.instance.currentUser!.uid;
  late List<RequestData> bookings;

  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('requests')
                .orderBy(
              'timestamp',
              descending: true,
            )
                .where('SCid', isEqualTo: SCid)
                .snapshots(),
            builder: (context,snapshot) {

              if (snapshot.hasData) {
                final bookings = snapshot.data!.docs;

                return Column(
                  children: [

                    Stack(
                      children: [
                        Container(
                          height: 200.0,
                          width: double.infinity, // set the width to the full screen width
                          decoration: BoxDecoration(
                            gradient: LinearGradient(

                              colors: [Colors.deepPurple.shade600, Colors.deepPurple.shade200],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            // set rounding at the bottom corners only
                          ),

                        ),
                        Positioned(child: Text('Bookings', style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),),
                          top: 160,
                          left: 10,
                        )
                      ],
                    ),//purple


                    for (final booking in bookings)
                      if( booking['status']=='accepted' )
                        BookingListItem(
                          date: DateFormat("d MMMM").format(booking['timestamp'].toDate()),
                          time:"" ,
                          id: booking.id,
                          place: booking['locality'],
                          service: booking['SPid'] ,
                          description: booking['workDescription']!,
                          status: booking['status']!,
                        ),
                    SizedBox(height: 50,)
                  ],
                );

              } else {
                return Center(
                  heightFactor: 100,
                  child: CircularProgressIndicator(),
                );
              }
            }
        ),
      ),
    );
  }

  Future<String> GetData() async {
    List<String> ids = await getRequestIdsForSCid(SCid);
    print(ids);
    bookings = await getRequestsByIds(ids);
    return 'done';
  }



}

class BookingListItem extends StatelessWidget {
  BookingListItem({
    Key? key,
    required this.date,
    required this.time,
    required this.place,
    required this.service,
    required this.description,
    required this.status,
    required this.id,

  }) : super(key: key);

  final String date;
  final String time;
  final String place;
  final String service;
  final String description;
  final String status;
  final String id;

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance.collection('providers').doc(service);
    return FutureBuilder<DocumentSnapshot>(
      future: ref.get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if(!snapshot.data!.exists)return Container();
          String name = snapshot.data!['name'];
          return ExpansionTile(
            collapsedBackgroundColor: (status== 'accepted')?Colors.deepPurple.shade200.withOpacity(0.6): Colors.grey.shade300  ,
            textColor: Colors.black,

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2))),
            backgroundColor: (status== 'accepted')?Colors.deepPurple.shade50.withOpacity(0.4): Colors.grey.shade200,
            title: Text(name, style: TextStyle(fontWeight: FontWeight.bold),),
            collapsedShape: ContinuousRectangleBorder(),
            controlAffinity: ListTileControlAffinity.leading,
            subtitle: Text(place, style: TextStyle(color: Colors.black54, fontSize: 12),),
            trailing: SizedBox(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    status=='accepted'?IconButton(onPressed: (){
                      createChatroomAndStartConversation(FirebaseAuth.instance.currentUser!.uid, service, context);

                    },
                      icon: Icon(Icons.sms_rounded),):SizedBox(),
                    Text(date, style: TextStyle(fontSize: 14),),
                  ]
              ),
              width: 150,

            ),
            children: <Widget>[

              ListTile(
                title: Align(
                    alignment: Alignment.topLeft, child: (status == 'sent')?Text('Waiting For Response...'):Text('Accepted')),
                subtitle: Align(
                    alignment: Alignment.bottomLeft, child: Text(description)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                        child: Icon(Icons.delete_forever_outlined, color: Colors.purple.shade300, size: 30,),
                        onPressed: (){

                          Widget cancelButton = ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) {
                                // If the button is pressed, return green, otherwise blue
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.deepPurple.shade200;
                                }
                                return Colors.purple;
                              }),
                            ),
                            child: const Text(
                              "No",
                              style: TextStyle(

                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop(); // close the dialog
                            },
                          );

                          Widget deleteButton = ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) {
                                // If the button is pressed, return green, otherwise blue
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.purple.shade200;
                                }
                                return Colors.purple;
                              }),
                            ),
                            child: const Text(
                              "Yes",
                              style: TextStyle(

                                fontWeight: FontWeight.bold,

                              ),
                            ),
                            onPressed: () {
                              cancelRequest(id);
                              CherryToast.info(title: Text('Request Deleted'));
                              Navigator.of(context, rootNavigator: true).pop();
                              // close the dialog
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: Text(
                              "Are you sure?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            content: Text(
                              "Deleting this request cannot be undone.",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            actions: [
                              cancelButton,
                              deleteButton,
                            ],
                          );

                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }

                    ),
                    (status == 'accepted')? MaterialButton(
                        child: Icon(Icons.reviews, color: Colors.purple.shade300, size: 30,),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Write a Review'),
                              content: ReviewForm(SPid: service,),
                            ),
                          );

                        }

                    ) : SizedBox(),
                  ],
                ),

              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple.shade400,
            )
            ,
            widthFactor:2,
            heightFactor: 2,
          );
        }
      },
    );

  }
}





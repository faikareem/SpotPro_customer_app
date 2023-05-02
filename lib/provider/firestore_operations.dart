import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String? name;
  final String? service;
  final String? description;
  final String? number;

  DataModel({this.name, this.service, this.description, this.number});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return DataModel(
          name: dataMap['name'],
          service: dataMap['service'],
          description: dataMap['description'],
          number: dataMap['number']);
    }).toList();
  }
}

Future<List<Map<String, dynamic>>> retrieveProvidersData() async {
  List<Map<String, dynamic>> providersList = [];

  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('providers').get();

  querySnapshot.docs.forEach((doc) {
    Map<String, dynamic> providerData = {
      'name': doc['name'],
      'location': doc['location'],
      'jobDescription': doc['job description'],
      'number': doc['number'],
      'department': doc['department']
    };

    providersList.add(providerData);
  });

  return providersList;
}


Future<void> addRequestData({
  required String SCid,
  required String SPid,
  required Timestamp timestamp,
  required String name,
  required DateTime scheduled,
  required String locality,
  required String workDescription,
  required String status,
  required double lat,
  required double long,


}) async {
  // Add a new document to the "requests" collection
  DocumentReference requestDocRef =
  await FirebaseFirestore.instance.collection('requests').add({
    'SCid': SCid,
    'SPid': SPid,
    'timestamp': timestamp,
    'name': name,
    'scheduled': scheduled,
    'locality': locality,
    'workDescription': workDescription,
    'status' : status,
    'latlon':{'latitude':lat,'longitude':long}
  });

  await FirebaseFirestore.instance

      .collection('users')
      .doc(SCid).update({
    'requestcount': FieldValue.increment(1),
  });

  // Get the ID of the newly created document
  String requestId = requestDocRef.id;

  // Update the "Requid" document in the "SCrequests" subcollection
  DocumentReference scRequidDocRef = await FirebaseFirestore.instance
      .collection('SCrequests')
      .doc(SCid)
      .collection('Requid')
      .add({
    'requestId': requestId,
  });


  // Update the "Requid" document in the "SPrequests" subcollection
  DocumentReference spRequidDocRef = await FirebaseFirestore.instance
      .collection('SPrequests')
      .doc(SPid)
      .collection('Requid')
      .add({
    'requestId': requestId,
  });
}

Future<List<String>> getRequestIdsForSCid(String SCid) async {
  CollectionReference spRequidCollectionRef = FirebaseFirestore.instance
      .collection('SCrequests')
      .doc(SCid)
      .collection('Requid');

  QuerySnapshot spRequidSnapshot = await spRequidCollectionRef.get();
  List<String> requestIds = [];
  spRequidSnapshot.docs.forEach((doc) {
    requestIds.add(doc['requestId']);


  });

  return requestIds;
}

class RequestData {
  String? SCid;
  String? SPid;
  DateTime? timestamp;
  String? name;
  String? locality;
  String? workDescription;
  String? status;
  String? id;

  RequestData({
    this.SCid = 'default',
    this.SPid  = 'default',
     this.timestamp ,
     this.name  = 'default',
     this.locality  = 'default',
     this.workDescription  = 'default',
    this.status = 'default',
    this.id = 'default',
  });

  RequestData.fromJson(Map<String, dynamic> json) {
    SCid = json['SCid'];
    SPid = json['SPid'];
    timestamp = json['timestamp'].toDate();
    name = json['name'];
    locality = json['locality'];
    workDescription = json['workDescription'];
    status = json['status'];
  }
}

class ProviderData {
  String? name;
  String? SPid;
  String? location;
  String? rate;
  String? service;
  String? description;
  String? phonenumber;

  ProviderData({
    this.name = 'default',
    this.SPid  = 'default',
    this.location  = 'default',
    this.rate  = 'default',
    this.service  = 'default',
    this.description = 'default',
    this.phonenumber = 'default',
  });

  ProviderData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    SPid = json['uid'];
    location = json['location'];
    rate = json['rate'];
    phonenumber = json['phoneNumber'];
    description = json['desc'];
    service = json['service'];
  }
}

Future<List<RequestData>> getRequestsByIds(List<String> ids) async {
  List<RequestData> requests = [];

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('requests')
      .where(FieldPath.documentId, whereIn: ids)
      .get();

  querySnapshot.docs.forEach((doc) {
    Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
    RequestData requestData = RequestData.fromJson(data);
    requests.add(requestData);
  });




  return requests;
}

Future<List<ProviderData>> getProviders() async {
  List<ProviderData> providers = [];

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('providers')
      .get();
  print(querySnapshot.docs[0].data().toString());
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
    ProviderData providerData = ProviderData.fromJson(data);
    providers.add(providerData);
    print(providerData.name);
  }




  return providers;
}

void cancelRequest(String requestId) {
  FirebaseFirestore.instance
      .collection('requests') // specify the collection name
      .doc(requestId) // specify the document ID
      .update({'status': 'canceled'}) // update the 'status' field to 'canceled'
      .then((value) => print('Request $requestId has been canceled.'))
      .catchError((error) => print('Failed to cancel request: $error'));
}
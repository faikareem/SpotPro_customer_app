import 'package:flutter/material.dart';
import '../provider/firestore_operations.dart';
import 'searchresults.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Catcard extends StatelessWidget {
  const Catcard({

    this.name = 'Cat Name',
    this.url = 'Cat url',
  });

  final String name;
  final String url;
  @override
  Widget build(BuildContext context) {


    return ElevatedButton(

      onPressed: () {

        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => ResultsList(category: name)
        ));
      },
      style: ElevatedButton.styleFrom(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // make it square shaped
        ),
        minimumSize: Size(90, 90),
        maximumSize: Size(90, 90),
        backgroundColor: Color.fromRGBO(255, 255, 255, 50)// set size to 90px x 90px
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 1),
          Image.network(
            url,
            height: 40,
            width: 40,
            color: Colors.black45,
          ),
          // add some space between image and text
          Text(
            name,
            style: TextStyle(fontSize: 10, color: Colors.black45),
          ),
          SizedBox(height: 1,)
        ],
      ),
    );

  }
}
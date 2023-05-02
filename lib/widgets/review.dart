import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class ReviewForm extends StatefulWidget {
  final String SPid;


  const ReviewForm({Key? key, required this.SPid}) : super(key: key);
  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {

  final _formKey = GlobalKey<FormState>();
  String _reviewText = '';
  double _rating = 3.0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(

            decoration: InputDecoration(
              labelText: 'Write your review',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your review text';
              }
              return null;
            },
            onSaved: (value) {
              _reviewText = value!;
            },
          ),
          SizedBox(height: 16.0),

          //Text('Rating: $_rating'),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 40,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.purple,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel',style: TextStyle(color: Colors.purple),),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitReview(widget.SPid);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitReview(String SPid) async {
    final name = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String nameSC = name.data()!['name'];
    try {

      final reviewData = {
        'text': _reviewText,
        'rating': _rating,
        'SPid': SPid,
        'SCname': nameSC,
        'SCid': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': Timestamp.now(),
      };
      await FirebaseFirestore.instance

          .collection('reviews')
          .add(reviewData);
      await FirebaseFirestore.instance

          .collection('providers')
          .doc(SPid).update({
        'review.1': FieldValue.increment(1),
      'review.2': FieldValue.increment(_rating),
      });
      await FirebaseFirestore.instance

          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid).update({
        'reviewcount': FieldValue.increment(1),
      });
      Navigator.of(context).pop();
    } catch (e) {
      print('Error submitting review: $e');
    }
  }
}

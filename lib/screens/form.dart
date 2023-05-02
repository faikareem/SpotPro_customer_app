import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../provider/firestore_operations.dart';
import 'package:provider/provider.dart';
import 'package:spotpro_customer/provider/auth_provider.dart';


// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular((20.0)),),
                  ),
                  border: OutlineInputBorder()),

              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Locality',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular((20.0)),),
                  ),
                  border: OutlineInputBorder()),

              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Work',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular((20.0)),),
                  ),
                  border: OutlineInputBorder()),

              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                  }

                  else print('error');
                },
                child: const Text('Submit' ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
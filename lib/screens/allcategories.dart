import 'package:flutter/material.dart';
import 'components.dart';
import 'package:google_fonts/google_fonts.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Categories';

    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.workSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: title,
      home: Scaffold(

        appBar: AppBar(backgroundColor: Colors.purple,
          title: const Text(title),
        ),

        body: GridView.count(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: EdgeInsets.all(10),
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 4,
          // Generate 100 widgets that display their index in the List.
          children: [
            Catcard(name: 'Carpenter', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Fcarpenter.png?alt=media&token=9f49536b-d92b-4f10-9722-04d0c06fd5fe',),
            Catcard(name: 'Painter', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Froller.png?alt=media&token=5c890a50-d9ef-4b0c-bfca-7d1f40b43309',),
            Catcard(name: 'AC Repair', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Fair-conditioner%20(1).png?alt=media&token=71a927ab-0575-49e8-9fba-3a11d22d8904',),

            Catcard(name: 'Cleaning', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Fbroom.png?alt=media&token=e4479bb4-b80f-4d64-83bd-6e08053202a6',),
            Catcard(name: 'Chef', url: 'https://firebasestorage.googleapis.com/v0/b/spotprocustomer.appspot.com/o/services%2Ffork.png?alt=media&token=b18db1fc-bda0-4da1-9825-786750c77dbd',),
          ],
        ),
      ),
    );
  }
}
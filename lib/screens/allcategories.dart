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
          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 4,
          // Generate 100 widgets that display their index in the List.
          children: [
            Catcard(name:'Carpenter'),
            Catcard(name:'Painter'),
            Catcard(name:'AC Repair'),
            Catcard(name:'Plumber'),
            Catcard(name:'Home Chef'),
          ],
        ),
      ),
    );
  }
}
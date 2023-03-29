import 'package:flutter/material.dart';


class ScrollList extends StatelessWidget {
  const ScrollList({super.key,});

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(

          children: [
            Image.network('https://i.ibb.co/1ZfVKmf/adf6e07d-b0df-44ca-8dbb-f99f4d627d9e.png'),
            for (final booking in bookings)
              BookingListItem(
                date: booking.date,
                time: booking.time,
                place: booking.place,
                url: booking.url,
              ),

          ],
        ),
      ),
    );
  }
}

// class BookingListItem extends StatelessWidget {
//   BookingListItem({ super.key, required this.date,
//     required this.time,
//     required this.place,
//     required this.url,
//   });
//
//   final String date;
//   final String time;
//   final String place;
//   final String url;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//       child: AspectRatio(
//         aspectRatio: 16 / 9,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Stack(
//             children: [
//               Gradient(),
//               TitleAndSubtitle(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget Gradient() {
//     return Positioned.fill(
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Colors.lightBlue.shade100],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: const [0.6, 0.95],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget TitleAndSubtitle() {
//     return Positioned(
//       left: 20,
//       bottom: 20,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             date,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             time,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//             ),
//           ),
//           Text(
//             place,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class BookingListItem extends StatelessWidget {
  BookingListItem({
    Key? key,
    required this.date,
    required this.time,
    required this.place,
    required this.url,
  }) : super(key: key);

  final String date;
  final String time;
  final String place;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:4,
      surfaceTintColor: Colors.purple,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              child: Image.network(
                'https://i.ibb.co/wy8dCq6/7fe5a7bd4d994bdd1eb02b61ef3aae08.webp',
                fit: BoxFit.fitHeight,
                scale: 1,
                opacity: AlwaysStoppedAnimation(0.7),
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Divider(),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),


                  Divider(),
                  Text(
                    time,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class booking {
  const booking({
    required this.date,
    required this.time,
    required this.place,
    required this.url,
  });

  final String date;
  final String time;
  final String place;
  final String url;

}
  const bookings= [
    booking(
      date: '29-03-2022', time: '1:00 pm', place: 'Kunnamangalam',
      url: 'URL',
    ),
    booking(
      date: '31-03-2022', time: '1:00 pm', place: 'Kunnamangalam',
      url: 'URL',
    ),
    booking(
      date: '01-04-2022', time: '1:00 pm', place: 'Kunnamangalam',
      url: 'URL',
    ),
  ];


import 'package:flutter/material.dart';

class Catcard extends StatelessWidget {
  const Catcard({

    this.name = 'Cat Name',
  });

  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //border: Border.all(color: Color(0xffeeeeee), width: 2.0),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            

            blurRadius: 5,
            spreadRadius: 0.2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      margin: EdgeInsets.all(8),
      height: 90,
      width: 90,
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: SizedBox(
                child: Image.network('https://i.ibb.co/68Hv5Py/air-conditioner.png',
                  fit: BoxFit.fitWidth,
                  opacity: const AlwaysStoppedAnimation(.5),
                ),
                height: 50,
                width: 50,
              )
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
                color: Colors.grey),
          ),
        ],
      ),
      
    );
  }
}
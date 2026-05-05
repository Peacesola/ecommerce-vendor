import 'package:flutter/material.dart';

class Shortcut extends StatelessWidget {
  final String text;
  final IconData icon;
  const Shortcut({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        /*border: Border.all(
          color: Colors.black,
          width: 2
        ),*/
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 0),
          BoxShadow(
              color: Colors.white,
              offset: Offset(-10, -10),
              blurRadius: 10,
              spreadRadius: 0),
          BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 0),
          BoxShadow(
              color: Colors.white,
              offset: Offset(0, -11),
              blurRadius: 10,
              spreadRadius: 0),
        ]
      ),
      height: 120,
      //width: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Container(
             padding: const EdgeInsets.all(6),
               decoration: BoxDecoration(
                 border: Border.all(
                     color: Colors.black,
                     width: 2
                 ),
                 borderRadius: BorderRadius.circular(35)
             ),
               child: Icon(icon,size: 50,),
           ),
            SizedBox(height: 10,),
            Text(text,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),)
          ],
        ),
      ),
    );
  }
}

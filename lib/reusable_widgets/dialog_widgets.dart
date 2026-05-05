import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/login_page.dart';

class DialogWidgets {
  void showErrorDialog(BuildContext context, String response){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Text(response),
        title: Text("An error occurred"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK',style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    });
  }


  void logout(BuildContext context){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Text("Are you sure you want to logout?"),
        title: Text("Logout?"),
        actions: [
          TextButton(
            onPressed:()async{
              final prefs= await SharedPreferences.getInstance();
              await prefs.clear();
              if(context.mounted){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(route) => false,);
              }
            },
            child: Text('Yes',style: TextStyle(color: Colors.black),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No',style: TextStyle(color: Colors.black),),
          ),
        ],
      );

    } );
  }

  void showTokenExpiredDialog(BuildContext context ){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Text("Oops, your session seems to have expired! Log in again to continue."),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text('OK',style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    });
  }

  void showDeleteFoodDialog(BuildContext context, Future<void>Function() delete ){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Delete food?"),
        content: Text("This food will be deleted permanently. Tap cancel to cancel action."),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              delete();
            },
            child: Text('Delete',style: TextStyle(color: Colors.black),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel',style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    });
  }
}
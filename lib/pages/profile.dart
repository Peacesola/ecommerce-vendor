import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_constants.dart';
import '../entities/restaurant.dart';
import '../reusable_widgets/dialog_widgets.dart';
import 'login_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ApiConstants apiConstants= ApiConstants();
  DialogWidgets dialog= DialogWidgets();


  Future<Restaurant?>me()async {
    try{
      final prefs= await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final url= Uri.parse(apiConstants.me);
      final response= await http.get(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if(response.statusCode==200){
        final data= jsonDecode(response.body);
        return Restaurant.fromJson(data);
      }else if(response.statusCode==401){
        final prefs= await SharedPreferences.getInstance();
        await prefs.clear();
        if (mounted) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(route) => false,);
          dialog.showTokenExpiredDialog(context);
        }
      }
      else{
        return null;
      }
    }catch (e) {
      if (mounted) {
        dialog.showErrorDialog(context, e.toString());
      }
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text("Profile",style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
         SizedBox(
           height: 120,
           width: 120,
           child: CircleAvatar(
                   backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.grey,
            ),
           ),
         ),
            SizedBox(height: 10,),
            SizedBox(height: 40,),
            ListTile(
                onTap: () {},
                leading: Icon(Icons.person_outline_outlined),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Restaurant name",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500,)
                        ,overflow: TextOverflow.ellipsis,),
                      FutureBuilder<Restaurant?>(
                          future: me(),
                          builder: (context, snapshot){
                            if(snapshot.connectionState== ConnectionState.waiting){
                              return Text("Loading...",style: TextStyle(fontSize: 18,)
                                ,overflow: TextOverflow.ellipsis,);
                            }if(snapshot.hasError){
                              return Text("An error occurred while loading name",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500)
                                ,overflow: TextOverflow.ellipsis,);
                            }
                            final data = snapshot.data;
                            final name= data?.restaurantName??"";
                            return Text(name,style: TextStyle(fontSize: 18)
                              ,overflow: TextOverflow.ellipsis,);
                          }),
                    ]
                )
            ),
            ListTile(
                onTap: () {},
                leading: Icon(Icons.email_outlined),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Restaurant email",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500,)
                        ,overflow: TextOverflow.ellipsis,),
                      FutureBuilder<Restaurant?>(
                          future: me(),
                          builder: (context, snapshot){
                            if(snapshot.connectionState== ConnectionState.waiting){
                              return Text("Loading...",style: TextStyle(fontSize: 18,)
                                ,overflow: TextOverflow.ellipsis,);
                            }if(snapshot.hasError){
                              return Text("An error occurred while loading email",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500)
                                ,overflow: TextOverflow.ellipsis,);
                            }
                            final data = snapshot.data;
                            final email= data?.email??"";
                            return Text(email,style: TextStyle(fontSize: 18)
                              ,overflow: TextOverflow.ellipsis,);
                          }),
                    ]
                )
            ),
            ListTile(
                onTap: () {},
                leading: Icon(Icons.badge_outlined),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Restaurant id",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500,)
                        ,overflow: TextOverflow.ellipsis,),
                      FutureBuilder<Restaurant?>(
                          future: me(),
                          builder: (context, snapshot){
                            if(snapshot.connectionState== ConnectionState.waiting){
                              return Text("Loading...",style: TextStyle(fontSize: 18,)
                                ,overflow: TextOverflow.ellipsis,);
                            }if(snapshot.hasError){
                              return Text("An error occurred while loading id",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500)
                                ,overflow: TextOverflow.ellipsis,);
                            }
                            final data = snapshot.data;
                            final id= data?.restaurantId??"";
                            return Text(id.toString(),style: TextStyle(fontSize: 18)
                              ,overflow: TextOverflow.ellipsis,);
                          }),
                    ]
                )
            ),
            ListTile(
                onTap: () {},
                leading: Icon(Icons.info_outline),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Restaurant status",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500,)
                        ,overflow: TextOverflow.ellipsis,),
                      FutureBuilder<Restaurant?>(
                          future: me(),
                          builder: (context, snapshot){
                            if(snapshot.connectionState== ConnectionState.waiting){
                              return Text("Loading...",style: TextStyle(fontSize: 18,)
                                ,overflow: TextOverflow.ellipsis,);
                            }if(snapshot.hasError){
                              return Text("An error occurred while loading status",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500)
                                ,overflow: TextOverflow.ellipsis,);
                            }
                            final data = snapshot.data;
                            bool state= data?.isOpen??false;
                            return state?Text("Open",style: TextStyle(fontSize: 18)
                              ,overflow: TextOverflow.ellipsis,):Text("Closed",style: TextStyle(fontSize: 18)
                              ,overflow: TextOverflow.ellipsis,);
                          }),
                    ]
                )
            ),
            ListTile(
                onTap: () {
                  dialog.logout(context);
                },
                leading: Icon(Icons.logout),
                title: Text("Logout",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500,)
                  ,overflow: TextOverflow.ellipsis,),
            )
          ],
        )
      ),
    );
  }
}

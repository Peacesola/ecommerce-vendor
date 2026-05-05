import 'dart:convert';

import 'package:ecommerce_personal_vendor/api/api_constants.dart';
import 'package:ecommerce_personal_vendor/entities/restaurant.dart';
import 'package:ecommerce_personal_vendor/pages/add_new_product.dart';
import 'package:ecommerce_personal_vendor/pages/orders_naviagtion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../reusable_widgets/dialog_widgets.dart';
import '../reusable_widgets/shortcut.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late Future<Restaurant?> future;
  ApiConstants apiConstants = ApiConstants();
  DialogWidgets dialog = DialogWidgets();



  Future<void> toggleState(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final toggleUrl = "https://e-commerce-fuya.onrender.com/api/v1/restaurant/restaurantStatus/$id";
    final url = Uri.parse(toggleUrl);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String message = data["message"];
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );
        setState(() {
           me();
        });
      }
    }else if(response.statusCode==401){
      final prefs= await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(route) => false,);
        dialog.showTokenExpiredDialog(context);
      }
    }
  }

  Future<Restaurant?> me() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final url = Uri.parse(apiConstants.me);
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Restaurant.fromJson(data);
      }else if(response.statusCode==401){
        final prefs= await SharedPreferences.getInstance();
        await prefs.clear();
        if (mounted) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(route) => false,);
          dialog.showTokenExpiredDialog(context);
        }
      }
      else {
        return null;
      }
    } catch (e) {
      if (mounted) {
        dialog.showErrorDialog(context, e.toString());
      }
    }
    return null;
  }

  @override
  void initState() {
    me();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
        //toolbarHeight: 15,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Good day",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            FutureBuilder<Restaurant?>(
              future: me(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Loading...",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return Expanded(
                    child: Text(
                      "An error occurred while loading name",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }
                final data = snapshot.data;
                final name = data?.restaurantName??"";
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdersNaviagtion(),
                        ),
                      );
                    },
                    child: Shortcut(
                      text: "Orders",
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Shortcut(
                      text: "Revenue",
                      icon: Icons.monetization_on_outlined,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Shortcut(
                      text: "Reviews",
                      icon: Icons.rate_review_outlined,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewProduct(),
                        ),
                      );
                    },
                    child: Shortcut(
                      text: "Add product",
                      icon: Icons.add_outlined,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FutureBuilder<Restaurant?>(
              future: me(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    leading: Text(
                      "Restaurant status",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: CircularProgressIndicator(color: Colors.black),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    "An error occurred while loading name",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  );
                }
                final data = snapshot.data;
                final id = data?.restaurantId;
                bool status = data?.isOpen??false;
                return Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        "Restaurant status",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: status,
                      onChanged: (value) {
                        toggleState(id!);
                      },
                    ),
                    status
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Open",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Closed",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

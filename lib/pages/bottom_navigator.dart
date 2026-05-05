import 'package:ecommerce_personal_vendor/pages/home_page.dart';
import 'package:ecommerce_personal_vendor/pages/orders.dart';
import 'package:ecommerce_personal_vendor/pages/products.dart';
import 'package:ecommerce_personal_vendor/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int currentIndex= 0;
  List<Widget>pages=[
    HomePage(),
    Products(),
    Orders(),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          tabs: [
        GButton(icon: Icons.dashboard,text: "Dashboard",),
        GButton(icon: Icons.fastfood,text: "Products",),
        GButton(icon: Icons.shopping_bag,text: "Orders",),
        GButton(icon: Icons.person,text: "Profile",)
      ],
        selectedIndex: currentIndex,
        onTabChange: (index){
            setState(() {
              currentIndex=index;
            });
        },
      ),
    );
  }
}

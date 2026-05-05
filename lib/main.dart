import 'package:ecommerce_personal_vendor/pages/bottom_navigator.dart';
import 'package:ecommerce_personal_vendor/pages/home_page.dart';
import 'package:ecommerce_personal_vendor/pages/login_page.dart';
import 'package:ecommerce_personal_vendor/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> checkToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted){
      if(prefs.containsKey("token")){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavigator()), (route) => false,);
      }else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>RegisterPage()), (route) => false,);
      }
    }
  }

  @override void initState() {
   checkToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       //  backgroundColor: Colors.black,
       // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: CircularProgressIndicator(color: Colors.green,),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text("Orders",style: TextStyle(color: Colors.white),),
        //toolbarHeight: 15,
      ),
      body:RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.black,
        onRefresh: (){
          throw Exception();
        },
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),)
    );
  }
}

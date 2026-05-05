import 'dart:convert';

import 'package:ecommerce_personal_vendor/api/api_constants.dart';
import 'package:ecommerce_personal_vendor/pages/add_new_product.dart';
import 'package:ecommerce_personal_vendor/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/food.dart';
import '../reusable_widgets/dialog_widgets.dart';
import 'login_page.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  ApiConstants apiConstants= ApiConstants();
  DialogWidgets dialog= DialogWidgets();
  List<Food>? food= [];

  Future<void> allFoodItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final url = Uri.parse(apiConstants.getAllFoodItemsUrl);
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        setState(() {
           food= data.map((e)=>Food.fromJson(e)).toList();
        });
      } else if(response.statusCode==401){
        final prefs= await SharedPreferences.getInstance();
        await prefs.clear();
        if (mounted) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(route) => false,);
          dialog.showTokenExpiredDialog(context);
        }
      }
      else {
        return;
      }
    } catch (e) {
      if (mounted) {
        dialog.showErrorDialog(context, e.toString());
      }
    }
    return;
  }

  Future<void> deleteFoodItem(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String deleteFoodItemUrl="https://e-commerce-fuya.onrender.com/api/v1/food/deleteFood/$id";
      final token = prefs.getString("token");
      final url = Uri.parse(deleteFoodItemUrl);
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 204) {
        setState(() {
          allFoodItems();
        });
      } else if(response.statusCode==401){
        final prefs= await SharedPreferences.getInstance();
        await prefs.clear();
        if (mounted) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(route) => false,);
          dialog.showTokenExpiredDialog(context);
        }
      }
      else {
        return;
      }
    } catch (e) {
      if (mounted) {
        dialog.showErrorDialog(context, e.toString());
      }
    }
    return;
  }

  @override
  void initState() {
    allFoodItems();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text("Products", style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewProduct()),
          );
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        tooltip: "Add new product",
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.black,
        onRefresh: allFoodItems,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: food!.isEmpty?Center(child: CircularProgressIndicator(color: Colors.black,),):
          ListView.builder(
              itemCount: food?.length,
              itemBuilder: (context,index){
                String name= food?[index].name??"";
                String description= food?[index].description??"";
                double price= food?[index].price??0.0;
                bool isAvailable= food?[index].isAvailable??false;
                /*Map<String,dynamic>addOns= data?[index].addOns??{};*/
                Map<String, dynamic> addOns = Map<String, dynamic>.from(food?[index].addOns ?? {});
                int productId= food?[index].productId??0;
                return InkWell(
                  onTap: () {
                    print(productId);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                        name:name,
                        description:description,
                        price: price,
                        isAvailable:isAvailable,
                        addOns:addOns,
                        productId:productId
                    )));
                  },
                  onLongPress: ()async {
                    dialog.showDeleteFoodDialog(context, ()async{
                      await deleteFoodItem(productId);
                    });
                  },
                  child: Container(
                    height: 130,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-10, -10),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0, -11),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: double.maxFinite,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          description,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "NGN $price",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // width: 70,
                                    height: 25,
                                    padding: const EdgeInsets.only(left: 4,right: 4),
                                    decoration: BoxDecoration(
                                      color: isAvailable?Colors.green:Colors.red,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Text(
                                        isAvailable?"Available":"Not available",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
        ),
      ),
    );
  }

  /*Widget _foodTile(BuildContext context) {
    return InkWell(
      onTap: () {},
      onLongPress: () {},
      child: Container(
        height: 130,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-10, -10),
              blurRadius: 10,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(0, -11),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: double.maxFinite,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Food Nameeeeeeeeeeeeeeeeee",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Descriptionnnnnnnnnnnnnnnnnnnnnnnnnnnn",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "\$5.99",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 70,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/


/*FutureBuilder<List<Food>?>(
              future: allFoodItems(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
                if(!snapshot.hasData){
                  return Center(
                    child: Text(
                      "No products yet",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }
                if(snapshot.hasError){
                  return Center(
                    child: Expanded(
                      child: Text(
                        "An error occurred",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }
                final data= snapshot.data;
                return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context,index){
                      String name= data?[index].name??"";
                      String description= data?[index].description??"";
                      double price= data?[index].price??0.0;
                      bool isAvailable= data?[index].isAvailable??false;
                      /*Map<String,dynamic>addOns= data?[index].addOns??{};*/
                      Map<String, dynamic> addOns = Map<String, dynamic>.from(data?[index].addOns ?? {});
                      int productId= data?[index].productId??0;
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                            name:name,
                            description:description,
                            price: price,
                            isAvailable:isAvailable,
                            addOns:addOns,
                            productId:productId
                          )));
                        },
                        onLongPress: () {},
                        child: Container(
                          height: 130,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 0),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-10, -10),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 0),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(0, -11),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: double.maxFinite,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                name,
                                                style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                description,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "NGN $price",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // width: 70,
                                          height: 25,
                                          padding: const EdgeInsets.only(left: 4,right: 4),
                                          decoration: BoxDecoration(
                                            color: isAvailable?Colors.green:Colors.red,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Center(
                                            child: Text(
                                              isAvailable?"Available":"Not available",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              })*/

}

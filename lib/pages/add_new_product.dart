import 'dart:convert';

import 'package:ecommerce_personal_vendor/entities/food.dart';
import 'package:ecommerce_personal_vendor/reusable_widgets/reusable_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_constants.dart';
import '../reusable_widgets/dialog_widgets.dart';
import 'login_page.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  ApiConstants apiConstants= ApiConstants();
  DialogWidgets dialog= DialogWidgets();
  Map<dynamic, dynamic>additives= {};
  bool availability= false;
  TextEditingController nameController=TextEditingController();
  TextEditingController priceController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController additiveNameController=TextEditingController();
  TextEditingController additivePriceController=TextEditingController();
  bool isLoading= false;
  void onTapped(){
    setState(() {
      isLoading=!isLoading;
    });
  }

  Future<void>createFood(BuildContext context)async {
    onTapped();
    try{
      final url= Uri.parse(apiConstants.createFoodUrl);
    Food food= Food(
        price: double.parse(priceController.text.trim()),
        name: nameController.text.trim(),
        addOns: additives,
        isAvailable: availability,
        description: descriptionController.text.trim());
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final request= food.toJson();
    final body = jsonEncode(request);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body
    );
    if(response.statusCode==201){
      final data= jsonDecode(response.body);
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"]),backgroundColor: Colors.green,)
        );
      }
    }else if(response.statusCode==401){
      final prefs= await SharedPreferences.getInstance();
      await prefs.clear();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(route) => false,);
        dialog.showTokenExpiredDialog(context);
      }
    }
    else{
      final data= jsonDecode(response.body);
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["message"]),backgroundColor: Colors.red,)
        );
      }
    }
    }catch(e){
      if(context.mounted){
        dialog.showErrorDialog(context, e.toString());
      }
    }

    onTapped();
  }


  void addAdditives(){
   if(additiveNameController.text.isNotEmpty&&additivePriceController.text.isNotEmpty){
     setState(() {
       additives.addAll({
         additiveNameController.text.trim():double.parse(additivePriceController.text.trim())
       });
     });
     additiveNameController.clear();
     additivePriceController.clear();
   }
  }

  void removeAdditives(Object key){
    setState(() {
      additives.remove(key);
    });
  }

  @override
  void initState() {
    nameController;
    priceController;
    descriptionController;
    additiveNameController;
    additivePriceController;
    super.initState();
  }

  @override
  void dispose() {
    nameController;
    priceController;
    descriptionController;
    additiveNameController;
    additivePriceController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add new product",style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text("Add a new food item",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
              ],
            ),
            SizedBox(height: 20,),
            ReusableTextFormField(controller: nameController, labelText: 'Food name',maxLines: 1,obscureText: false,),
            SizedBox(height: 10,),
            ReusableTextFormField(keyboardType: TextInputType.number,controller: priceController, labelText: 'Food price',maxLines: 1,obscureText: false,),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text("Add additives (Optional)",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
              ],
            ),
            SizedBox(height: 10,),
            ReusableTextFormField(controller: additiveNameController, labelText: 'Additive name',maxLines: 1,obscureText: false,),
            SizedBox(height: 10,),
            ReusableTextFormField(keyboardType: TextInputType.number,controller: additivePriceController, labelText: 'Additive price',maxLines: 1,obscureText: false,),
            additives.isEmpty?SizedBox(height: 10,):
            ListView.builder(
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: additives.length,
                itemBuilder: (context,index){
                  final key = additives.keys.elementAt(index);
                  final value = additives[key];
              return InkWell(
                onTap: (){
                  removeAdditives(key);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$key: $value",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.delete))
                  ],
                ),
              );
            }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: (){
                  addAdditives();
                }, child: Text("Add Additive")),
            SizedBox(height: 10,),
            SwitchListTile(
                title: Text("Food availability",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                value: availability, onChanged: (value){
              setState(() {
                availability=value;
              });
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                availability?Text("Available",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600))
                    :Text("Not available",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
              ],
            ),
            SizedBox(height: 10,),
            ReusableTextFormField(
              minLines: 8,
              maxLines: 8,
              controller: descriptionController, labelText: 'Food description',obscureText: false,),
            SizedBox(height: 20,),
            isLoading?
            Center(child: CircularProgressIndicator(color: Colors.black,)):
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
                onPressed: (){
               if(nameController.text.isEmpty||priceController.text.isEmpty||descriptionController.text.isEmpty){
                 if(context.mounted){
                   showDialog(context: context, builder: (context){
                     return AlertDialog(
                       backgroundColor: Colors.white,
                       content: Text("All required fields must be filled."),
                       actions: [
                         TextButton(
                           onPressed: () {
                             Navigator.of(context).pop();
                           },
                           child: Text('Ok',style: TextStyle(color: Colors.black),),
                         ),
                       ],
                     );
                   } );
                 }
               }
                else{
                 createFood(context);
               }
                }, child: Text("Add Food")),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}

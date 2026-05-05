import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_constants.dart';
import '../entities/food.dart';
import '../reusable_widgets/dialog_widgets.dart';
import '../reusable_widgets/reusable_text_form_field.dart';
import 'login_page.dart';

class EditProduct extends StatefulWidget {
  final String name;
  final String description;
  final double price;
   bool? isAvailable;
  final Map<String,dynamic>addOns;
  final int productId;
   EditProduct({super.key,
    required this.name, required this.description,
    required this.price,  this.isAvailable,
    required this.addOns, required this.productId});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ApiConstants apiConstants= ApiConstants();
  DialogWidgets dialog= DialogWidgets();
  bool availability= false;
  TextEditingController nameController=TextEditingController();
  TextEditingController priceController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController additiveNameController=TextEditingController();
  TextEditingController additivePriceController=TextEditingController();
  bool isLoading= false;
  bool isLoading2= false;
  void onTapped(){
    setState(() {
      isLoading=!isLoading;
    });
  }
  void onTapped2(){
    setState(() {
      isLoading2=!isLoading2;
    });
  }



  Future<void>updateFood(BuildContext context)async {
    onTapped();
    try{
      final updateUrl = "https://e-commerce-fuya.onrender.com/api/v1/food/updateFood/${widget.productId}";
      final url= Uri.parse(updateUrl);
      Food food= Food(
          price: double.parse(priceController.text),
          //name: nameController.text.trim(),
          //addOns: widget.addOns,
          isAvailable: widget.isAvailable!,
          description: descriptionController.text.trim());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final request= food.toJson();
      final body = jsonEncode(request);
      final response = await http.put(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: body
      );
      if(response.statusCode==200){
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

  void addOnDialog(BuildContext context){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Additive"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReusableTextFormField(controller: additiveNameController, labelText: 'Additive name',maxLines: 1,obscureText: false,),
              SizedBox(height: 10,),
              ReusableTextFormField(keyboardType: TextInputType.number,controller: additivePriceController, labelText: 'Additive price',maxLines: 1,obscureText: false,),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed:(){
              addAdditives();
              Navigator.of(context).pop();
            },
            child: Text('Add',style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    } );
  }


  Future<void> toggleAvailability(int id) async {
    setState(() {
      onTapped2();
    });
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final toggleUrl = "https://e-commerce-fuya.onrender.com/api/v1/food/foodAvailability/$id";
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
      }
    }else if(response.statusCode==401){
      final prefs= await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(route) => false,);
        dialog.showTokenExpiredDialog(context);
      }
    }
    setState(() {
      onTapped2();
    });
  }


  void addAdditives(){
    if(additiveNameController.text.isNotEmpty&&additivePriceController.text.toString().isNotEmpty){
      setState(() {
        widget.addOns.addAll({
          additiveNameController.text.trim():additivePriceController.text.trim()
        });
      });
      additiveNameController.clear();
      additivePriceController.clear();
    }
    // print(additives);
  }

  void removeAdditives(Object key){
    setState(() {
      widget.addOns.remove(key);
    });
  }

  @override
  void initState() {
    nameController.text=widget.name;
    priceController.text=widget.price.toString();
    descriptionController.text=widget.description;
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
        title: Text("Edit product",style: TextStyle(color: Colors.white),),
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
                Expanded(child: Text("Food",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
              ],
            ),
            SizedBox(height: 20,),
            //ReusableTextFormField(controller: nameController, labelText: 'Food name',maxLines: 1,obscureText: false,),
            SizedBox(height: 10,),
            ReusableTextFormField(keyboardType: TextInputType.number,controller: priceController, labelText: 'Food price',maxLines: 1,obscureText: false,),
            SizedBox(height: 20,),
           /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Additives",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
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
                      addOnDialog(context);
                    }, child: Row(
                      children: [
                        Icon(Icons.add_outlined),
                        SizedBox(width: 5,),
                        Text("Add Additive"),
                      ],
                    )),
              ],
            ),
            SizedBox(height: 10,),
           widget.addOns.isEmpty?SizedBox(height: 10,):
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.addOns.length,
                itemBuilder: (context,index){
                  final key = widget.addOns.keys.elementAt(index);
                  final value = widget.addOns[key];
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
                }),*/
            SizedBox(height: 10,),
            isLoading2?
            ListTile(
              leading: Text(
                "Food availability",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: CircularProgressIndicator(color: Colors.black),
            ):
            SwitchListTile(
                title: Text("Food availability",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
              value: widget.isAvailable!,
              onChanged: (value) {
                setState(() {
                  toggleAvailability(widget.productId);
                });
              },),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.isAvailable!?Text("Available",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600))
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
                    updateFood(context);
                  }
                }, child: Text("Update")),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}

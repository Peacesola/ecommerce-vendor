import 'dart:convert';

import 'package:ecommerce_personal_vendor/api/api_constants.dart';
import 'package:ecommerce_personal_vendor/entities/restaurant.dart';
import 'package:ecommerce_personal_vendor/pages/login_page.dart';
import 'package:ecommerce_personal_vendor/reusable_widgets/dialog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../reusable_widgets/reusable_text_form_field.dart';
import 'bottom_navigator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ApiConstants apiConstants= ApiConstants();
  DialogWidgets dialog= DialogWidgets();
  bool isOpen= false;
  TextEditingController restaurantNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool isLoading= false;
  void onTapped(){
    setState(() {
      isLoading=!isLoading;
    });
  }

  Future<void>registerRestaurant(BuildContext context)async {
    onTapped();
    try{
      final url= Uri.parse(apiConstants.registerUrl);
      Restaurant restaurant= Restaurant(restaurantName: restaurantNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          isOpen: isOpen);
      final request= restaurant.toJson();
      final body = jsonEncode(request);
      final response= await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: body
      );
      if(response.statusCode==201){
        final data= jsonDecode(response.body);
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data["message"]),backgroundColor: Colors.green,)
          );
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
        }

      }else if (response.statusCode==409){
        final data= jsonDecode(response.body);
        if(context.mounted){
          dialog.showErrorDialog(context, data["message"]);
        }
      }else{
        final data= jsonDecode(response.body);
        if(context.mounted){
          dialog.showErrorDialog(context, data["message"]);
        }
      }
    }catch(e){
      if(context.mounted){
        dialog.showErrorDialog(context, e.toString());
      }
    }
    onTapped();
  }

  @override
  void initState() {
    restaurantNameController;
    emailController;
    passwordController;
    super.initState();
  }
  @override
  void dispose() {
    restaurantNameController;
    emailController;
    passwordController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Register",style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: Text("Register a restaurant",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
                ],
              ),
              SizedBox(height: 20,),
              ReusableTextFormField(controller: restaurantNameController, labelText: 'Restaurant name',
              maxLines: 1,obscureText: false,
              ),
              SizedBox(height: 10,),
              ReusableTextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController, labelText: 'Email',maxLines: 1,obscureText: false,),
              SizedBox(height: 10,),
              ReusableTextFormField(
                controller: passwordController, labelText: 'Password',maxLines: 1,obscureText: true,),
              SwitchListTile(
                  title: Text("Restaurant status",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                  value: isOpen, onChanged: (value){
                setState(() {
                  isOpen=value;
                });
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isOpen?Text("Open",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600))
                      :Text("Closed",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: double.maxFinite,
                child: isLoading?
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
                       if(restaurantNameController.text.isNotEmpty&&emailController.text.isNotEmpty&&passwordController.text.isNotEmpty){
                         registerRestaurant(context);
                       }
                    }, child: Text("Register")),
              ),
              SizedBox(height: 20,),
              Center(
                child: Column(
                  children: [
                    Text("Already have an account?"),
                    TextButton(onPressed: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),(route) => false,);
                    }, child: Text("Login",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }

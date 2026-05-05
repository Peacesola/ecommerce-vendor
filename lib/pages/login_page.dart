import 'dart:convert';

import 'package:ecommerce_personal_vendor/api/api_constants.dart';
import 'package:ecommerce_personal_vendor/pages/bottom_navigator.dart';
import 'package:ecommerce_personal_vendor/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/restaurant.dart';
import '../reusable_widgets/dialog_widgets.dart';
import '../reusable_widgets/reusable_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DialogWidgets dialog= DialogWidgets();
  ApiConstants apiConstants = ApiConstants();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool isLoading= false;
  void onTapped(){
    setState(() {
      isLoading=!isLoading;
    });
  }

  Future<void>loginRestaurant(BuildContext context)async {
   try{
     onTapped();
     final url= Uri.parse(apiConstants.loginUrl);
     Restaurant restaurant= Restaurant(
       email: emailController.text.trim(),
       password: passwordController.text.trim(),
     );
     final request= restaurant.toJson();
     final body = jsonEncode(request);
     final response= await http.post(url,
         headers: {
           "Content-Type": "application/json",
         },
         body: body
     );
     if(response.statusCode==200){
       final data= jsonDecode(response.body);
       final token= data["restaurant"]["token"];
       final prefs= await SharedPreferences.getInstance();
       await prefs.setString("token", token);
       if(context.mounted){
         ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(data["message"]),backgroundColor: Colors.green,)
         );
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>BottomNavigator()),(route) => false,);
         //print(data);
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
    emailController;
    passwordController;
    super.initState();
  }
  @override
  void dispose() {
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
        title: Text("Login",style: TextStyle(color: Colors.white),),
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
                  Expanded(child: Text("Login",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
                ],
              ),
              SizedBox(height: 20,),
              ReusableTextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController, labelText: 'Email',maxLines: 1,obscureText: false,),
              SizedBox(height: 10,),
              ReusableTextFormField(
                controller: passwordController, labelText: 'Password',maxLines: 1,obscureText: true,),
              SizedBox(height: 20,),
              SizedBox(
                width: double.maxFinite,
                child: isLoading?
                Center(child: CircularProgressIndicator(color: Colors.black,)):ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: (){
                      if(emailController.text.isNotEmpty&&passwordController.text.isNotEmpty){
                        loginRestaurant(context);
                      }
                    }, child: Text("Login")),
              ),
              SizedBox(height: 20,),
              Center(
                child: Column(
                  children: [
                    Text("Don't have an account?"),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
                    }, child: Text("Register",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),))
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

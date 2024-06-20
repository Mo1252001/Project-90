import 'package:clincapp/screens/home_patient.dart';
import 'package:clincapp/screens/register.dart';
import 'package:clincapp/services/repositories/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/user_model.dart';
import 'home_doctor.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  UserModel? currentUser ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                        child: Text("Login", style: TextStyle(color: Colors.cyan,
                            fontSize: 30,
                            fontWeight: FontWeight.bold))),
                    SizedBox(height: 50),
                    TextField(
                        controller: userNameController,
                        decoration: const InputDecoration(labelText: 'Username',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)))),
                        keyboardType: TextInputType.name),
                    const SizedBox(height: 15),
                    TextField(
                        controller: passController,
                        decoration: const InputDecoration(labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)))),
                        keyboardType: TextInputType.text,obscureText: true,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Do not have an account?",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Register()));
                            },
                            child: const Text(
                              "register",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color.fromRGBO(
                                      36, 54, 101, 1.0),
                                  decorationThickness: 2,
                                  color: Color.fromRGBO(36, 54, 101, 1.0),
                                  fontSize: 15),
                            ))
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            print('current:'+currentUser.toString());
                            if(userNameController.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please, Enter your Username')));
                            }else if(passController.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please, Enter your Password')));
                            }else{
                              currentUser=await ApiRepository().login(userNameController.text, passController.text,this.context);
                              if(currentUser!=null){
                                final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                                await sharedPreferences.setInt('user_id', currentUser!.id!);
                                await sharedPreferences.setString('user_fname', currentUser!.firstName!);
                                await sharedPreferences.setString('user_lname', currentUser!.lastName!);
                                await sharedPreferences.setString('role', currentUser!.role!);
                                if(currentUser?.role=='doctor'){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeDoctor()));
                                }else{
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePatient()));
                                }
                              }
                            }
                          },
                          child: Text('Login'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.white)),
                    )
                  ])),
        ));
  }
}
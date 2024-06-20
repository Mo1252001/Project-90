import 'package:clincapp/response/user_model.dart';
import 'package:clincapp/screens/home_doctor.dart';
import 'package:clincapp/screens/home_patient.dart';
import 'package:clincapp/services/repositories/api_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  bool isDoctor = true;
  bool isPatient = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  UserModel user = UserModel();
  UserModel? currentUser;
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
            Center(
                child: Text("Registration",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 30,
                        fontWeight: FontWeight.bold))),
            SizedBox(height: 50),
            TextField(
                controller: userNameController,
                decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                keyboardType: TextInputType.name),
            SizedBox(height: 15),
            TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                keyboardType: TextInputType.name),
            SizedBox(height: 15),
            TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                keyboardType: TextInputType.name),
            SizedBox(height: 15),
            TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                keyboardType: TextInputType.emailAddress),
            SizedBox(height: 15),
            TextField(
                controller: passController,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                obscureText: true),
            SizedBox(height: 15),
            TextField(
                controller: confirmPassController,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                obscureText: true),
            SizedBox(height: 15),
            Row(
              children: [
                Radio(
                    value: true,
                    groupValue: isDoctor,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          isDoctor = value;
                          isPatient = !value;
                        });
                      }
                    }),
                Text('Doctor'),
                SizedBox(width: 10),
                Radio(
                    value: true,
                    groupValue: isPatient,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          isPatient = value;
                          isDoctor = !value;
                        });
                      }
                    }),
                Text('Patient')
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    if (userNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please, Enter Your Username')));
                    } else if (firstNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please, Enter Your First Name')));
                    } else if (lastNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please, Enter your Last Name')));
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please, Enter a Valid Email')));
                    } else if (passController.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Please, Enter a Password over 6 digits')));
                    } else if (confirmPassController.text !=
                        passController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please, Confirm Your Password')));
                    } else {
                      print(currentUser);
                      if (isDoctor) {
                       user = UserModel(
                            username: userNameController.text,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            password: confirmPassController.text,
                            role: 'doctor');
                      } else {
                        user = UserModel(
                            username: userNameController.text,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            password: confirmPassController.text,
                            role: 'patient');
                      }
                      try {
                        currentUser= await ApiRepository().createUser(user, this.context);
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something Wrong')));
                      }
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
                  child: Text('Regiester'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white)),
            )
          ],
        ),
      ),
    ));
  }
}

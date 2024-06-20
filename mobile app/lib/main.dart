import 'package:clincapp/response/user_model.dart';
import 'package:clincapp/screens/home_doctor.dart';
import 'package:clincapp/screens/home_patient.dart';
import 'package:clincapp/screens/login.dart';
import 'package:clincapp/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  int? id= sharedPreferences.getInt('user_id');
  String? role=sharedPreferences.getString('role');
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
  home:id==null
  ?Login(): role=='doctor' ?HomeDoctor() :HomePatient(),));
}

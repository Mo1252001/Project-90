import 'dart:convert';

import 'package:clincapp/response/appointment_model.dart';
import 'package:clincapp/response/prescription_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../response/user_model.dart';

class ApiRepository {
  static const String uri = 'http://192.168.1.12:5000';

  Future<UserModel> createUser(UserModel user, BuildContext x) async {
    http.Response response =
        await http.post(Uri.parse('${uri}/api/create_user'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': "*/*",
              'connection': 'keep-alive',
              'Accept-Encoding': 'gzip, deflate, br',
            },
            body: jsonEncode(user.toJson()));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      print(response.body);
      ScaffoldMessenger.of(x).showSnackBar(SnackBar(content: Text('Registed')));
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception();
    }
  }

  Future<UserModel> getUserById(int id) async {
    http.Response response =
        await http.get(Uri.parse('${uri}/api/get_user/${id}'));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  Future<List<UserModel>> getUsersByRole(String role) async {
    http.Response response =
        await http.get(Uri.parse('${uri}/api/get_users/${role}'));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      List userList = jsonDecode(response.body);
      return userList.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }

  Future<UserModel> login(
      String? userName, String? pass, BuildContext x) async {
    http.Response response = await http.post(Uri.parse("${uri}/api/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
          'Accept-Encoding': 'gzip, deflate, br',
        },
        body: jsonEncode({'username': userName, 'password': pass}));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      ScaffoldMessenger.of(x)
          .showSnackBar(SnackBar(content: Text("Wrong Email or Password")));
      throw Exception();
    }
  }

  Future<void> createAppointment(
      int patient,int doctor,String date ,BuildContext x) async {
    http.Response response =
        await http.post(Uri.parse('${uri}/api/create_appointment'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': "*/*",
              'connection': 'keep-alive',
              'Accept-Encoding': 'gzip, deflate, br',
            },
            body: jsonEncode({'appointment_date':date,'patient_id':patient,'doctor_id':doctor}));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      ScaffoldMessenger.of(x)
          .showSnackBar(SnackBar(content: Text('Appointment Created')));
    } else {
      throw Exception();
    }
  }

  Future<void> addPrescription(
      PrescriptionModel prescription, BuildContext x) async {
    http.Response response =
        await http.post(Uri.parse('${uri}/api/add_prescription'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': "*/*",
              'connection': 'keep-alive',
              'Accept-Encoding': 'gzip, deflate, br',
            },
            body: jsonEncode(prescription.toJson()));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      ScaffoldMessenger.of(x)
          .showSnackBar(SnackBar(content: Text('Prescription Added')));
    } else {
      throw Exception();
    }
  }

  Future<void> editAppointment(
      int id, AppointmentModel appointment, BuildContext x) async {
    http.Response response =
        await http.put(Uri.parse('${uri}/api/edit_appointment/${id}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': "*/*",
              'connection': 'keep-alive',
              'Accept-Encoding': 'gzip, deflate, br',
            },
            body: jsonEncode(appointment.toJson()));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      ScaffoldMessenger.of(x)
          .showSnackBar(SnackBar(content: Text('Appointment Edited')));
    } else {
      throw Exception();
    }
  }

  Future<void> deleteAppointment(int id, BuildContext x) async {
    http.Response response =
        await http.delete(Uri.parse('${uri}/api/edit_appointment/${id}'));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      ScaffoldMessenger.of(x)
          .showSnackBar(SnackBar(content: Text('Appointment Deleted')));
    } else {
      throw Exception();
    }
  }

  Future<void> editPrescription(
      int id, PrescriptionModel prescription, BuildContext x) async {
    http.Response response =
        await http.put(Uri.parse('${uri}/api/edit_prescription/${id}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': "*/*",
              'connection': 'keep-alive',
              'Accept-Encoding': 'gzip, deflate, br',
            },
            body: jsonEncode(prescription.toJson()));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      ScaffoldMessenger.of(x)
          .showSnackBar(SnackBar(content: Text('Prescription Edited')));
    } else {
      throw Exception();
    }
  }

  Future<void> deletePrescription(int id, BuildContext x) async {
    http.Response response =
        await http.delete(Uri.parse('${uri}/api/edit_prescription/${id}'));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      ScaffoldMessenger.of(x)
          .showSnackBar(SnackBar(content: Text('Prescription Deleted')));
    } else {
      throw Exception();
    }
  }
  Future<List<AppointmentModel>> getAppointmentAsDoctor(int id,BuildContext x) async {
    http.Response response=await http.get(Uri.parse('${uri}/api/get_appointments_as_doctor/${id}'));
    if (response.statusCode < 300 && response.statusCode >= 200){
      List <dynamic> appointmentList=json.decode(response.body);
      return appointmentList.map((json) => AppointmentModel.fromJson(json as Map<String,dynamic>)).toList();
    }else{
      throw Exception();
    }
  }
  Future<List<AppointmentModel>> getAppointmentAsPatient(int id,BuildContext x) async {
    http.Response response=await http.get(Uri.parse('${uri}/api/get_appointments_as_patient/${id}'));
    if (response.statusCode < 300 && response.statusCode >= 200){
      List <dynamic> appointmentList=json.decode(response.body);
      return appointmentList.map((json) => AppointmentModel.fromJson(json as Map<String,dynamic>)).toList();
    }else{
      throw Exception();
    }
  }
}

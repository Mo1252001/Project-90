import 'package:clincapp/response/prescription_model.dart';
import 'package:clincapp/response/user_model.dart';
import 'package:clincapp/screens/appointment_details.dart';
import 'package:clincapp/screens/login.dart';
import 'package:clincapp/services/repositories/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/appointment_model.dart';
import 'appointment_details_patient.dart';

class HomeDoctor extends StatefulWidget {

  @override
  State<HomeDoctor> createState() {
    return HomeDoctorState();
  }
}

class HomeDoctorState extends State<HomeDoctor> {
  late Future<List<AppointmentModel>> listAppointment;

  @override
  void initState() {
  listAppointment=getAppointments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Home', style: TextStyle(color: Colors.white)),
              TextButton(onPressed: () async {
                final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                await sharedPreferences.remove('user_id');
                await sharedPreferences.remove('user_fname');
                await sharedPreferences.remove('user_lname');
                await sharedPreferences.remove('role');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
              },style: TextButton.styleFrom(backgroundColor: Colors.white) ,child: Text('Logout',style: TextStyle(color: Colors.cyan),))
            ],
          ),
          backgroundColor: Colors.cyan,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            children: [
               Text(
                'My Appointments',
                style: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.w400,
                    fontSize: 25),
              ),
              FutureBuilder<List<AppointmentModel>>(
                future: listAppointment,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)));
                  } else if (snapshot.hasData) {
                    List<AppointmentModel> appointments = snapshot.data!;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AppointmentDetails(
                                              appointments[index])));
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text('Doctor Name:'),
                                      Text(appointments[index]
                                          .doctor
                                          .toString())
                                    ]),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text('Date:'),
                                        Text(appointments[index]
                                            .appointmentDate
                                            .toString())
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      color:
                                      appointments[index].approved ==
                                          true
                                          ? Colors.green
                                          : Colors.red,
                                      child: Text(
                                          appointments[index].approved ==
                                              true
                                              ? 'Approved'
                                              : 'Not Approved'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(child: Text('No Appointments',style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),);
                  }
                },
              )
            ],
          ),
        )));
  }
  Future<List<AppointmentModel>> getAppointments() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    int? id = sharedPreferences.getInt('user_id');
    List<AppointmentModel> list =
    await ApiRepository().getAppointmentAsPatient(id!, this.context);
    return list;
  }
}
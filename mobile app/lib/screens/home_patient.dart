import 'package:clincapp/response/user_model.dart';
import 'package:clincapp/screens/appointment_details_patient.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/appointment_model.dart';
import '../services/repositories/api_repository.dart';
import 'login.dart';

class HomePatient extends StatefulWidget {
  @override
  State<HomePatient> createState() {
    return HomePatientState();
  }
}

class HomePatientState extends State<HomePatient> {
  late Future<List<AppointmentModel>> listAppointment;
  String? date;

  int? doctor;
  int? patient;
  TextEditingController year = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController day = TextEditingController();

  @override
  void initState() {
    listAppointment = getAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Home', style: TextStyle(color: Colors.white)),
              TextButton(
                  onPressed: () async {
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    await sharedPreferences.remove('user_id');
                    await sharedPreferences.remove('user_fname');
                    await sharedPreferences.remove('user_lname');
                    await sharedPreferences.remove('role');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.cyan),
                  ))
            ],
          ),
          backgroundColor: Colors.cyan,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        List<UserModel> doctors =
                            await ApiRepository().getUsersByRole('doctor');
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        patient = sharedPreferences.getInt('user_id');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Make an Appointment'),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    DropdownButtonFormField(
                                        decoration: InputDecoration(
                                            labelText: "Doctor",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        items: doctors
                                            .map((num) => DropdownMenuItem<
                                                    UserModel>(
                                                value: num,
                                                child: Text(
                                                    'Dr,${num.firstName} ${num.lastName}')))
                                            .toList(),
                                        onChanged: (UserModel? value) {
                                          if (value != null) {
                                            doctor = value.id;
                                            setState(() {});
                                          }
                                        }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                        controller: day,
                                        decoration: InputDecoration(
                                            labelText: 'Appointment Day',
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                        keyboardType: TextInputType.text),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                        controller: month,
                                        decoration: InputDecoration(
                                            labelText: 'Appointment Month',
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                        keyboardType: TextInputType.text),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                        controller: year,
                                        decoration: InputDecoration(
                                            labelText: 'Appointment Year',
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                        keyboardType: TextInputType.text),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      print('ddddddddd:${doctor}');
                                      if (doctor != null &&
                                          day.text.isNotEmpty &&
                                          month.text.isNotEmpty &&
                                          year.text.isNotEmpty) {
                                        date =
                                            "${year.text}-${month.text}-${day.text}";
                                        try {
                                          await ApiRepository()
                                              .createAppointment(patient!,
                                                  doctor!, date!, this.context);
                                          Navigator.of(context).pop();
                                        } on Exception catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(e.toString())));
                                        }
                                        setState(() {
                                          listAppointment=getAppointments();
                                        });
                                      }
                                    },
                                    child: Text('Make')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'))
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Make an Appointment',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(backgroundColor: Colors.cyan))
                ],
              ),
              SizedBox(height: 20),
              Text(
                'My Appointments',
                style: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.w400,
                    fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ), FutureBuilder<List<AppointmentModel>>(
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
                                                AppointmentDetailsPatient(
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

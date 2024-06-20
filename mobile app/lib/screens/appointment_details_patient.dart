import 'package:flutter/material.dart';

import '../response/appointment_model.dart';

class AppointmentDetailsPatient extends StatefulWidget {
  AppointmentModel appointment;

  AppointmentDetailsPatient(this.appointment);

  @override
  State<AppointmentDetailsPatient> createState() {
    return AppointmentDetailsPatientState();
  }
}

class AppointmentDetailsPatientState extends State<AppointmentDetailsPatient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            title: Text('Appointment Details',
                style: TextStyle(color: Colors.white))),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 110,
                          child: Text(
                            'Doctor Name:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                      Text(widget.appointment.doctor!)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: 110,
                          child: Text('Patient Name:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))),
                      Text(widget.appointment.patient!)
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                          width: 110,
                          child: Text('Date:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))),
                      Text(widget.appointment.appointmentDate!),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 110,
                          child: Text('Approval:',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        child: Text(widget.appointment.approved == true
                            ? 'Approved'
                            : 'Not Approved'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      widget.appointment.prescription == null
                          ? Row(
                        children: [
                          SizedBox(
                              width: 110,
                              child: Text('Prescription:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                          Text('No Prescription Added'),
                        ],
                      ) : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Prescription:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 80, child: Text('Diagnosis:')),
                              Text(widget.appointment.prescription![0].diagnosis!)
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(width: 80, child: Text('Details:')),
                              Expanded(
                                  child: Text(
                                      widget.appointment.prescription![0]
                                          .details!))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ]),
          ),
        ));
  }
}
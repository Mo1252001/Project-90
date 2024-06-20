import 'package:clincapp/response/prescription_model.dart';
import 'package:clincapp/screens/home_doctor.dart';
import 'package:flutter/material.dart';

import '../response/appointment_model.dart';
import '../services/repositories/api_repository.dart';

class AppointmentDetails extends StatefulWidget {
  AppointmentModel appointment;

  AppointmentDetails(this.appointment);

  @override
  State<AppointmentDetails> createState() {
    return AppointmentDetailsState();
  }
}

class AppointmentDetailsState extends State<AppointmentDetails> {
  TextEditingController editDate = TextEditingController();
  TextEditingController addDiagnosis=TextEditingController();
  TextEditingController addDetails=TextEditingController();
  TextEditingController editDiagnosis=TextEditingController();
  TextEditingController editDetails=TextEditingController();

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
                  Expanded(flex:1 ,
                    child: Visibility(
                        visible:
                            widget.appointment.approved == true ? false : true,
                        child: TextButton(
                            onPressed: () async {
                              AppointmentModel newAppointment =
                              AppointmentModel(
                                  appointmentDate: editDate.text,
                                  approved:
                                  true,
                                  patient:
                                  widget.appointment.patient,
                                  doctor:
                                  widget.appointment.doctor,
                                  prescription: widget
                                      .appointment.prescription);
                              try {
                                await ApiRepository().editAppointment(widget.appointment.id!, newAppointment, this.context);
                                widget.appointment.approved=true;
                              } on Exception catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something wrong')));
                              }
                              setState(() {
                              });
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: Text('Approve',style: TextStyle(color: Colors.white),))),
                  )
                ],
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
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Add Prescription'),
                                    content: Column(
                                      children: [
                                        TextField(
                                            controller: addDiagnosis,
                                            decoration: InputDecoration(
                                                labelText: 'Diagnosis',
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)))),
                                            keyboardType: TextInputType.text),
                                        SizedBox(height: 10,)
                                        ,TextField(
                                            controller: addDetails,
                                            decoration: InputDecoration(
                                                labelText: 'Details',
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)))),
                                            keyboardType: TextInputType.text)
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            if (addDiagnosis.text.isNotEmpty && addDetails.text.isNotEmpty) {
                                              List<PrescriptionModel> prescription=[PrescriptionModel(appointmentId: widget.appointment.id,diagnosis: addDiagnosis.text,details: addDetails.text)];
                                              try {
                                                await ApiRepository().addPrescription(prescription[0], this.context);
                                                widget.appointment.prescription=prescription;
                                                Navigator.of(context).pop();
                                              } on Exception catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something Wrong')));
                                              }
                                              setState(() {
                                              });
                                            }
                                          },
                                          child: Text('Add')),
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
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.cyan),
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ))
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text('Prescription:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Edit Prescription'),
                                          content: Column(
                                            children: [
                                              TextField(
                                                  controller: editDiagnosis,
                                                  decoration: InputDecoration(
                                                      labelText: 'Diagnosis',
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(10)))),
                                                  keyboardType: TextInputType.text),
                                              SizedBox(height: 10,),
                                              TextField(
                                                  controller: editDetails,
                                                  decoration: InputDecoration(
                                                      labelText: 'Details',
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(10)))),
                                                  keyboardType: TextInputType.text)
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  if (editDiagnosis.text.isNotEmpty && editDetails.text.isNotEmpty) {
                                                    List<PrescriptionModel> prescription=[PrescriptionModel(appointmentId: widget.appointment.id,diagnosis: editDiagnosis.text,details: editDetails.text)];
                                                    try {
                                                      await ApiRepository().editPrescription(widget.appointment.prescription![0].id!, prescription[0], this.context);
                                                      widget.appointment.prescription=prescription;
                                                      Navigator.of(context).pop();
                                                    } on Exception catch (e) {
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something Wrong')));
                                                    }
                                                    setState(() {
                                                    });
                                                  }
                                                },
                                                child: Text('Edit')),
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
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.cyan),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Prescription'),
                                          content: Text(
                                              'Are you sure you want to delete prescription?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  try {
                                                    await ApiRepository().deletePrescription(widget.appointment.prescription![0].id!, this.context);
                                                    widget.appointment.prescription=null;
                                                    Navigator.of(context).pop();
                                                  } on Exception catch (e) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(SnackBar(
                                                        content:
                                                        Text('Something Wrong')));
                                                  }
                                                  setState(() {
                                                  });
                                                },
                                                child: Text('Yes')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('No'))
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.cyan),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  )),
                            )
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
                                    widget.appointment.prescription![0].details!))
                          ],
                        )
                      ],
                    ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Edit Appointment'),
                              content: Column(
                                children: [
                                  TextField(
                                      controller: editDate,
                                      decoration: InputDecoration(
                                          labelText: 'Appointment Date',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      keyboardType: TextInputType.text),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      if (editDate.text.isNotEmpty) {
                                        AppointmentModel newAppointment =
                                            AppointmentModel(
                                                appointmentDate: editDate.text,
                                                approved:
                                                    widget.appointment.approved,
                                                patient:
                                                    widget.appointment.patient,
                                                doctor:
                                                    widget.appointment.doctor,
                                                prescription: widget
                                                    .appointment.prescription);
                                        try {
                                          await ApiRepository().editAppointment(
                                              widget.appointment.id!,
                                              newAppointment,
                                              this.context);
                                          widget.appointment=newAppointment;
                                          Navigator.of(context).pop();
                                        } on Exception catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something Wrong')));
                                        }
                                        setState(() {
                                        });
                                      }
                                    },
                                    child: Text('Edit')),
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
                      style: TextButton.styleFrom(backgroundColor: Colors.cyan),
                      child: Text('Edit Appointment',
                          style: TextStyle(color: Colors.white))),
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Appointment'),
                              content: Text(
                                  'Are you sure you want to delete appointment?'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      try {
                                        await ApiRepository().deleteAppointment(
                                            widget.appointment.id!,
                                            this.context);
                                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeDoctor()));
                                      } on Exception catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('Something Wrong')));
                                      }
                                    },
                                    child: Text('Yes')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No'))
                              ],
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(backgroundColor: Colors.cyan),
                      child: Text(
                        'Delete Appointment',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

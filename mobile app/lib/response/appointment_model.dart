import 'package:clincapp/response/prescription_model.dart';

class AppointmentModel {
  int? id;
  String? appointmentDate;
  bool? approved;
  String? patient;
  String? doctor;
  List<PrescriptionModel>? prescription;

  AppointmentModel(
      {this.id,
      this.appointmentDate,
      this.approved,
      this.patient,
      this.doctor,this.prescription});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointmentDate = json['appointment_date'];
    approved = json['approved'];
    patient = json['patient'];
    doctor = json['doctor'];
    if(prescription!=null){
      prescription=<PrescriptionModel>[];
    prescription = json['prescriptions'].foreach((v){
    prescription!.add(new PrescriptionModel.fromJson(v));
    });}
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_date': appointmentDate,
      'approved': approved,
      'patient': patient,
      'doctor': doctor,
      'prescriptions':prescription
    };
  }
}

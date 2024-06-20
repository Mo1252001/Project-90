class PrescriptionModel{
  int? id;
  int? appointmentId;
  String? diagnosis;
  String? details;

  PrescriptionModel({this.id,this.appointmentId,this.diagnosis,this.details});

  PrescriptionModel.fromJson(Map<String, dynamic> json){
    id=json['id'];
    appointmentId=json['appointment_id'];
    diagnosis=json['diagnosis'];
    details=json['details'];
  }
  Map<String,dynamic> toJson(){
    return{
      'appointment_id':appointmentId,
      'diagnosis':diagnosis,
      'details':details
    };
  }
}
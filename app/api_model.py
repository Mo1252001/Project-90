from .extentions import api
from flask_restx import fields


login_model = api.model('Login', {
    'username': fields.String(required=True, description='Username of the user'),
    'password': fields.String(required=True, description='Password of the user'),
})


user_model = api.model('User', {
    'id': fields.Integer(readonly=True),
    'username': fields.String(required=True, description='Username of the user'),
    'email': fields.String(required=True, description='email of the user'),
    'password': fields.String(required=True, description='Password of the user'),
    'first_name': fields.String(required=True, description='First name of the patient'),
    'last_name': fields.String(required=True, description='last name of the patient'),
    'role': fields.String(enum=['doctor','patient'], required=True, description="User Role ENUM('doctor','patient')"),
})

prescription_model_input = api.model('Prescription Input', {
    'id': fields.Integer(readonly=True),
    'diagnosis': fields.String(required=True, description='Diagnosis by the doctor'),
    'details': fields.String(required=True, description='Medication Schedule and how to take medicine'),
})

appoint_model = api.model('Appointment', {
    'id': fields.Integer(readonly=True),
    'appointment_date': fields.String(),
    'approved':     fields.Boolean(),
    'patient': fields.String(),
    'doctor': fields.String(),
    'prescriptions':fields.Nested(prescription_model_input,allow_null=True)
})

appoint_model_input = api.model('Appointment Input', {
    'id': fields.Integer(readonly=True),
    'appointment_date': fields.String(description='Appointment Date (YY-MM-DD)',example='2025-5-20'),
    'patient_id': fields.Integer(),
    'doctor_id': fields.Integer(),
})


prescription_model = api.model('Prescription', {
    'id': fields.Integer(readonly=True),
    'appointment_id': fields.Integer(required=True, description='ID of the appointment'),
    'diagnosis': fields.String(required=True, description='Diagnosis by the doctor'),
    'details': fields.String(required=True, description='Medication Schedule and how to take medicine'),
    'doctor': fields.String(readonly=True),
    'patient': fields.String(readonly=True)
})

# Define an error message model
error_message_model = api.model('ErrorMessage', {
    'message': fields.String(required=True, description='An error message'),
})
from sqlalchemy import Enum
from .extentions import db
from flask_login import UserMixin


class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150), nullable=False, unique=True)
    email = db.Column(db.String(150), nullable=False, unique=True)
    password = db.Column(db.String(150), nullable=False)
    first_name = db.Column(db.String(150), nullable=False)
    last_name = db.Column(db.String(150), nullable=False)
    role = db.Column(db.String(7), nullable=False)

    appointments_as_patient = db.relationship(
        'Appointment', foreign_keys='Appointment.patient_id', backref='patient', lazy=True)
    appointments_as_doctor = db.relationship(
        'Appointment', foreign_keys='Appointment.doctor_id', backref='doctor', lazy=True)

    def __repr__(self):
        return f'{self.first_name} {self.last_name}'

   

class Appointment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(
        db.Integer, db.ForeignKey('user.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    appointment_date = db.Column(db.DateTime, nullable=False)
    approved = db.Column(db.Boolean, default=False)

    prescriptions = db.relationship(
        'Prescription', backref='appointment', lazy=True)

    def __repr__(self):
        return f'Appointment with Doctor {self.doctor} and Patient {self.patient} on {self.appointment_date}'


class Prescription(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    appointment_id = db.Column(db.Integer, db.ForeignKey(
        'appointment.id'), nullable=False)
    diagnosis = db.Column(db.Text, nullable=False)
    details = db.Column(db.Text, nullable=False)

    def __repr__(self):
        return f'<Prescription {self.id} for Appointment {self.appointment_id}>'

    @property
    def doctor(self):
        return self.appointment.doctor

    @property
    def patient(self):
        return self.appointment.patient

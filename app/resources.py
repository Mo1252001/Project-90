from flask_restx import Resource, Namespace,marshal
from .api_model import *
from flask import Response, request, jsonify, abort
from .models import *
from .extentions import db, login_manager
from flask_login import login_user, current_user, login_required, logout_user
from datetime import datetime


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


ns = Namespace("api")


@ns.route('/edit_appointment/<int:appointment_id>')
class g(Resource):
    @ns.expect(appoint_model, mask=None)
    def put(self, appointment_id):
        """Edit an appointment by ID"""
        appoint = Appointment.query.filter_by(id=appointment_id).first_or_404()
        appoint.patient_id = ns.payload['patient_id']
        appoint.doctor_id = ns.payload['doctor_id']
        appoint.patient_id = ns.payload['patient_id']
        appoint.appointment_date = datetime.strptime(
            ns.payload['appointment_date'], r'%Y-%m-%d')
        appoint.approved = ns.payload['approved']

        try:
            db.session.commit()
            return {'message': 'Successfully Edited Appointment'}, 201
        except:
            db.session.rollback()
            return {'message': 'An Error occurred'}, 500

    def delete(self, appointment_id):
        """Delete an appointment by ID"""
        appoint = Appointment.query.filter_by(id=appointment_id).first_or_404()
        db.session.delete(appoint)
        try:
            db.session.commit()
            return {'message': 'Successfully Deleted Appointment'}, 201
        except:
            db.session.rollback()
            return {'message': 'An Error occurred'}, 500


@ns.route('/create_appointment')
class f(Resource):
    @ns.expect(appoint_model_input, mask=None)
    def post(self):
        """Create a new Appointment"""
        if True:
            new_appointment = Appointment(doctor_id=ns.payload['doctor_id'], patient_id=ns.payload['patient_id'], appointment_date=datetime.strptime(
                ns.payload['appointment_date'], r'%Y-%m-%d'))
            db.session.add(new_appointment)
            db.session.commit()
            return {'message': 'Successfully added Appointment'}, 201
        # except:
        #     db.session.rollback()
        #     if User.query.filter_by(id=ns.payload['doctor_id']).first() is None:
        #         return {'message': 'Doctor ID not found'}, 500
        #     elif User.query.filter_by(id=ns.payload['patient_id']).first() is None:
        #         return {'message': 'Patient ID not found'}, 500
        #     else:
        #         return {'message': 'An Error occurred'}, 500


@ns.route('/get_appointments_as_patient/<int:user_id>')
class e(Resource):
    @ns.marshal_list_with(appoint_model, mask=None)
    def get(self, user_id):
        """Get Appointments by patient ID"""
        return Appointment.query.filter_by(patient_id=user_id).all()


@ns.route('/get_appointments_as_doctor/<int:user_id>')
class d(Resource):
    @ns.marshal_list_with(appoint_model, mask=None)
    def get(self, user_id):
        """Get Appoinments by Doctors ID"""
        return Appointment.query.filter_by(doctor_id=user_id).all()


@ns.route('/create_user')
class users(Resource):
    @ns.expect(user_model,validate=True)
    #@ns.marshal_with(user_model,mask=None,code=201)
    @ns.response(500, 'Validation Error', error_message_model)
    @ns.response(201,'Successful input',user_model)
    def post(self):
        """Create a new User"""
        try:
            print(ns.payload)
            if ns.payload['role'] =='doctor' or ns.payload['role']=='patient':
                new_user = User(**ns.payload)
                db.session.add(new_user)
                db.session.commit()
               # return {'message':'asd'},200
                return marshal(new_user,user_model), 201
            else:
                return {'message': 'Cannot add user (Role Error)'}, 500
        except:
            db.session.rollback()
            if User.query.filter_by(username=ns.payload['username']).first():
                return {'message': 'Cannot add user (Username Already Taken)'}, 500
            elif User.query.filter_by(email=ns.payload['email']).first():
                return {'message': 'Cannot add user (Email Already Taken)'}, 500
            else:
                return {'message': 'Cannot add user '}, 500


@ns.route('/get_users/<string:role>')
class users2(Resource):
    @ns.marshal_list_with(user_model, mask=None)
    def get(self, role):
        return User.query.filter_by(role=role).all()


@ns.route('/get_user/<int:id>')
class users2(Resource):
    @ns.marshal_list_with(user_model, mask=None)
    def get(self, id):
        return User.query.filter_by(id=id).all()


@ns.route('/login')
class login(Resource):
    @ns.marshal_with(user_model,mask=None)
    @ns.expect(login_model)
    def post(self):
        user = User.query.filter_by(
            username=ns.payload['username'], password=ns.payload['password']).first_or_404()
        login_user(user)
        return user, 200


@ns.route('/logout')
class logout(Resource):
    # @login_required
    def post(self):
        try:
            if current_user.is_authenticated:
                logout_user()
                return {'message': f'Successfully Logged out'}, 200
            else:
                return {'message': f'User not logged in'}, 400
        except:
            return {'message': 'Server Error'}, 500




@ns.route('/add_prescription')
class b(Resource):
    @ns.expect(prescription_model, mask=None)
    def post(self):
        try:
            new_pres = Prescription(**ns.payload)
            db.session.add(new_pres)
            db.session.commit()
            return {'message': 'Successfully added prescription'}, 200
        except:
            db.session.rollback()
            return {'message': 'Cannot add prescription'}, 500


@ns.route('/edit_prescription/<int:prescription_id>')
class a(Resource):
    @ns.expect(prescription_model, mask=None)
    def put(self, prescription_id):
        pres = Prescription.query.filter_by(id=prescription_id).first_or_404()
        pres.appointment_id = ns.payload['appointment_id']
        pres.diagnosis = ns.payload['diagnosis']
        pres.details = ns.payload['details']
        try:
            db.session.commit()
            return {'message': 'Successfully Edited Prescription'}, 201
        except:
            db.session.rollback()
            return {'message': 'An Error occurred'}, 500

    def delete(self, prescription_id):
        prescription = Prescription.query.filter_by(
            id=prescription_id).first_or_404()
        db.session.delete(prescription)
        try:
            db.session.commit()
            return {'message': 'Successfully Deleted Appointment'}, 201
        except:
            db.session.rollback()
            return {'message': 'An Error occurred'}, 500

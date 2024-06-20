class UserModel {
  int? id;
  String? username;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? role;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.role});

  UserModel.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'role': role
    };
  }
}

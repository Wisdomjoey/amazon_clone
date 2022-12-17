import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String type;
  final String address;
  final String token;

  UserModel({required this.id, required this.name, required this.email, required this.password, required this.type,
      required this.address, required this.token});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'type': type,
      'address': address,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      type: map['type'],
      address: map['address'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

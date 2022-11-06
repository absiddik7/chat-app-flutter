import 'dart:convert';

class UserModel {
  UserModel({
    this.userId,
    this.name,
    this.email,
    this.profilepic,
  });

  String? userId;
  String? name;
  String? email;
  String? profilepic;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userId: json["userId"],
      name: json["name"],
      email: json["email"],
      profilepic: json['profilepic']);

  Map<String, dynamic> toJson() => {
        "id": userId,
        "name": name,
        "email": email,
        "profilepic": profilepic,
      };
}

import 'dart:convert';

class UserModel {
  UserModel({
    this.userId,
    this.name,
    this.email,
    this.profilepic,
    this.fcmtoken,
  });

  String? userId;
  String? name;
  String? email;
  String? profilepic;
  String? fcmtoken;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userId: json["userId"],
      name: json["name"],
      email: json["email"],
      profilepic: json['profilepic'],
      fcmtoken: json['fcmtoken']);

  Map<String, dynamic> toJson() => {
        "id": userId,
        "name": name,
        "email": email,
        "profilepic": profilepic,
        "fcmtoken": fcmtoken,
      };
}

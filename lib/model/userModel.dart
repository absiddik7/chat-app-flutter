import 'dart:convert';

class UserModel {
  UserModel({
    this.userId,
    this.name,
    this.email,
  });

  String? userId;
  String? name;
  String? email;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": userId,
        "name": name,
        "email": email,
      };
}

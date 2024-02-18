// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  final String? id;
  final String? name;
  final String? bio;

  UserData({
    this.id,
    this.name,
    this.bio,
  });

  UserData copyWith({
    String? id,
    String? name,
    String? bio,
  }) =>
      UserData(
        id: id ?? this.id,
        name: name ?? this.name,
        bio: bio ?? this.bio,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        bio: json["bio"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "bio": bio,
      };
}

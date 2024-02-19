import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory UserData.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserData(
      id: snapshot.id,
      name: snapshot["name"],
      bio: snapshot["bio"],
    );
  }
}

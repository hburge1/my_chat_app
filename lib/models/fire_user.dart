// To parse this JSON data, do
//
//     final fireUser = fireUserFromJson(jsonString);

import 'dart:convert';

FireUser fireUserFromJson(String str) => FireUser.fromJson(json.decode(str));

String fireUserToJson(FireUser data) => json.encode(data.toJson());

class FireUser {
  FireUser({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory FireUser.fromJson(Map<String, dynamic> json) => FireUser(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

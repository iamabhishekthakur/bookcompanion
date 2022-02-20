// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    required this.id,
    required this.nickName,
    required this.email,
    required this.profileUrl,
    required this.modifiedAt,
    required this.createdAt,
  });
  String id;
  String nickName;
  String email;
  String profileUrl;
  String modifiedAt;
  String createdAt;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        nickName: json["nick_name"],
        email: json["email"],
        profileUrl: json["profile_url"] ??
            'https://lippianfamilydentistry.net/wp-content/uploads/2015/11/user-default.png',
        modifiedAt: json["modified_at"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nick_name": nickName,
        "email": email,
        "profile_url": profileUrl,
        "modified_at": modifiedAt,
        "created_at": createdAt,
      };
}

// To parse this JSON data, do
//
//     final readingStatus = readingStatusFromJson(jsonString);

import 'dart:convert';

List<ReadingStatus> readingStatusFromJson(String str) =>
    List<ReadingStatus>.from(
        json.decode(str).map((x) => ReadingStatus.fromJson(x)));

String readingStatusToJson(List<ReadingStatus> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReadingStatus {
  ReadingStatus({
    required this.id,
    required this.title,
    required this.author,
    required this.modifiedAt,
    required this.fileUrl,
    required this.currentPage,
    required this.totalPage,
  });

  String id;
  String title;
  String author;
  String modifiedAt;
  String fileUrl;
  int currentPage;
  int totalPage;

  factory ReadingStatus.fromJson(Map<String, dynamic> json) => ReadingStatus(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        modifiedAt: json["modified_at"],
        fileUrl: json["file_url"],
        currentPage: json["current_page"] ?? 0,
        totalPage: json["total_page"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "modified_at": modifiedAt,
        "file_url": fileUrl,
        "current_page": currentPage,
        "total_page": totalPage,
      };
}

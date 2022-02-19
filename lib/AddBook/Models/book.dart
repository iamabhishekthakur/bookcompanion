// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.fileUrl,
    required this.categoryTitle,
    required this.addedByUserId,
    required this.insertTs,
    required this.keepBookPrivate,
  });

  String id;
  String title;
  String author;
  String fileUrl;
  String categoryTitle;
  String addedByUserId;
  String insertTs;
  bool keepBookPrivate;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        fileUrl: json["file_url"],
        categoryTitle: json["category_title"],
        addedByUserId: json["added_by_user_id"],
        insertTs: json["insert_ts"],
        keepBookPrivate: json["keep_book_private"] as bool,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "file_url": fileUrl,
        "category_title": categoryTitle,
        "added_by_user_id": addedByUserId,
        "insert_ts": insertTs,
        "keep_book_private": keepBookPrivate,
      };
}

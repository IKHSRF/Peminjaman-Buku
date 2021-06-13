import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String? id;
  final String title;
  final String detail;
  final String image;

  Book({
    this.id,
    required this.title,
    required this.detail,
    required this.image,
  });

  factory Book.fromFirestore(DocumentSnapshot snapshot) {
    return Book(
      id: snapshot.id,
      title: snapshot['title'],
      detail: snapshot['detail'],
      image: snapshot['image'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      'detail': detail,
      "image": image,
    };
  }
}

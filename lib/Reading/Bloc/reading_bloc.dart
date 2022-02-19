import 'package:bookcompanion/Homepage/Models/reading_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingBloc {
  Future<void> updateReadingStatusOfBook(ReadingStatus readingStatus) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('reading_status')
        .doc(readingStatus.id)
        .set(readingStatus.toJson());
  }
}

final readingBloc = ReadingBloc();

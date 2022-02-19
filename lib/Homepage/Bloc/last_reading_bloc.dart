import 'package:bookcompanion/Homepage/Models/reading_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LastReadingBloc {
  final PublishSubject<ReadingStatus> _lastReadingDataPublisher =
      PublishSubject<ReadingStatus>();
  Stream<ReadingStatus> get lastReadingData => _lastReadingDataPublisher.stream;
  Future<void> fetchLastReadingDetail() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .get()
        .then((value) {
      var readingStatus = ReadingStatus(
        id: value.get('last_reading_detail')['id'],
        title: value.get('last_reading_detail')['title'],
        author: value.get('last_reading_detail')['author'],
        modifiedAt: value.get('last_reading_detail')['modified_at'],
        currentPage: value.get('last_reading_detail')['current_page'],
        totalPage: value.get('last_reading_detail')['total_page'],
        fileUrl: value.get('last_reading_detail')['file_url'],
      );
      _lastReadingDataPublisher.sink.add(readingStatus);
    });
  }

  Future<void> publishLastReadingDetail(ReadingStatus readingStatus) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .update(
      {
        'last_reading_detail': readingStatus.toJson(),
      },
    );
    lastReadingBloc.fetchLastReadingDetail();
  }
}

final lastReadingBloc = LastReadingBloc();

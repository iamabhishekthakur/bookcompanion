import 'package:bookcompanion/Homepage/Models/reading_status.dart';
import 'package:bookcompanion/Utils/shared_preference_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LastReadingBloc {
  final PublishSubject<ReadingStatus?> _lastReadingDataPublisher =
      PublishSubject<ReadingStatus?>();
  Stream<ReadingStatus?> get lastReadingData =>
      _lastReadingDataPublisher.stream;
  Future<void> fetchLastReadingDetail() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(
          FirebaseAuth.instance.currentUser?.uid,
        )
        .collection('profiles')
        .doc(await sharedPreferenceHandler.getSelectedProfileID())
        .get()
        .then((value) {
      ReadingStatus? readingStatus;
      if (value.data()?.containsKey('last_reading_detail') ?? false) {
        readingStatus = ReadingStatus(
          id: value.get('last_reading_detail')['id'],
          title: value.get('last_reading_detail')['title'],
          author: value.get('last_reading_detail')['author'],
          modifiedAt: value.get('last_reading_detail')['modified_at'],
          currentPage: value.get('last_reading_detail')['current_page'],
          totalPage: value.get('last_reading_detail')['total_page'],
          fileUrl: value.get('last_reading_detail')['file_url'],
        );
      } else {
        readingStatus = null;
      }
      _lastReadingDataPublisher.sink.add(readingStatus);
    });
  }

  Future<void> publishLastReadingDetail(ReadingStatus readingStatus) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(
          FirebaseAuth.instance.currentUser?.uid,
        )
        .collection('profiles')
        .doc(await sharedPreferenceHandler.getSelectedProfileID())
        .update(
      {
        'last_reading_detail': readingStatus.toJson(),
      },
    );
    lastReadingBloc.fetchLastReadingDetail();
  }
}

final lastReadingBloc = LastReadingBloc();

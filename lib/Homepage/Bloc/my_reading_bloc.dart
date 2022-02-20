import 'package:bookcompanion/Homepage/Models/reading_status.dart';
import 'package:bookcompanion/Utils/shared_preference_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class MyReadingBloc {
  final PublishSubject<List<ReadingStatus>> _yourReadingDataPublisher =
      PublishSubject<List<ReadingStatus>>();
  Stream<List<ReadingStatus>> get yourReadingBookData =>
      _yourReadingDataPublisher.stream;
  Future<void> fetchYourReadingBookStatus() async {
    List<ReadingStatus> bookListOfReadings = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('profiles')
        .doc(await sharedPreferenceHandler.getSelectedProfileID())
        .collection('readings_list')
        .get()
        .then((event) {
      for (var doc in event.docs) {
        bookListOfReadings.add(
          ReadingStatus.fromJson(doc.data()),
        );
      }
    });
    _yourReadingDataPublisher.sink.add(bookListOfReadings);
  }

  void dispose() {
    _yourReadingDataPublisher.close();
  }
}

final myReadingBloc = MyReadingBloc();

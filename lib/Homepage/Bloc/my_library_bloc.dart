import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../AddBook/Models/book.dart';

class MyLibraryBloc {
  final PublishSubject<List<Book>> _myLibraryDataPublisher =
      PublishSubject<List<Book>>();
  Stream<List<Book>> get myLibraryBookData => _myLibraryDataPublisher.stream;
  Future<void> fetchMyLibraryData() async {
    List<Book> bookList = [];
    await FirebaseFirestore.instance
        .collection('books')
        .where(
          'keep_book_private',
          isEqualTo: true,
        )
        .where(
          'added_by_user_id',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
          isNotEqualTo: '',
          isNull: true,
        )
        .get()
        .then((event) {
      for (var doc in event.docs) {
        bookList.add(
          Book(
            id: doc.id,
            title: doc.get('title'),
            author: doc.get('author'),
            fileUrl: doc.get('file_url'),
            categoryTitle: doc.get('category_title'),
            addedByUserId: doc.get('added_by_user_id'),
            insertTs: doc.get('insert_ts'),
            keepBookPrivate: doc.get('keep_book_private'),
          ),
        );
      }
    });
    _myLibraryDataPublisher.sink.add(bookList);
  }

  void dispose() {
    _myLibraryDataPublisher.close();
  }
}

final MyLibraryBloc myLibraryBloc = MyLibraryBloc();

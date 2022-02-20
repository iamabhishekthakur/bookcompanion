import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../AddBook/Models/book.dart';

class PublicLibraryBloc {
  final PublishSubject<List<Book>> _publicLibraryDataPublisher =
      PublishSubject<List<Book>>();
  Stream<List<Book>> get publicLibraryBookData =>
      _publicLibraryDataPublisher.stream;
  Future<void> fetchPublicLibraryData() async {
    List<Book> bookList = [];
    await FirebaseFirestore.instance
        .collection('books')
        .where(
          'keep_book_private',
          isEqualTo: false,
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
            coverPictureUrl: doc.get('cover_picture_url'),
          ),
        );
      }
    });
    _publicLibraryDataPublisher.sink.add(bookList);
  }

  void dispose() {
    _publicLibraryDataPublisher.close();
  }
}

final PublicLibraryBloc publicLibraryBloc = PublicLibraryBloc();

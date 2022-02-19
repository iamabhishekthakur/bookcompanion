import 'package:bookcompanion/AddBook/Models/book.dart';
import 'package:bookcompanion/Homepage/Bloc/public_library_bloc.dart';
import 'package:bookcompanion/Utils/snackbar_handler.dart';
import 'package:bookcompanion/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Utils/progress_indicator_handler.dart';

class AddBookBloc {
  Future<List<String>> fetchBookGenres() async {
    List<String> bookGenres = [];
    try {
      await FirebaseFirestore.instance
          .collection('book_genres')
          .get()
          .then((value) {
        for (QueryDocumentSnapshot doc in value.docs) {
          bookGenres.add(doc.get('title'));
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return bookGenres;
  }

  Future<void> uploadBookData(Book bookDetail) async {
    try {
      ProgressIndicatorHandler().addCircularProgressIndicator();
      bookDetail.insertTs = DateTime.now().toUtc().toString();
      await FirebaseFirestore.instance.collection('books').doc().set(
            bookDetail.toJson(),
          );
      ProgressIndicatorHandler().removeLoadingIndicator();
      Navigator.pop(CustomKey.navigatorKey.currentState!.context);
      publicLibraryBloc.fetchAndListenForPublicBookDataChange();
      SnackBarHandler().showSuccessMessage('Book added successfully');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

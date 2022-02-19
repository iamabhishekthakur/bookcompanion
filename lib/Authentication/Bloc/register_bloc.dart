import 'package:bookcompanion/Homepage/View/homepage.dart';
import 'package:bookcompanion/Utils/progress_indicator_handler.dart';
import 'package:bookcompanion/Utils/snackbar_handler.dart';
import 'package:bookcompanion/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterBloc {
  Future<void> registerUser(String name, String email, String password) async {
    try {
      ProgressIndicatorHandler().addCircularProgressIndicator();
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'name': name,
        'selected_profile': '',
        'created_at': DateTime.now().toUtc().toString(),
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .collection('profiles')
          .doc()
          .set({
        'nick_name': name,
        'email': email,
        'profile_url': '',
        'created_at': DateTime.now().toUtc().toString(),
        'modified_at': DateTime.now().toUtc().toString(),
      });
      ProgressIndicatorHandler().removeLoadingIndicator();
      Navigator.push(
        CustomKey.navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        SnackBarHandler()
            .showErrorMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        SnackBarHandler()
            .showErrorMessage('The account already exists for that email.');
      }
    } catch (e) {
      SnackBarHandler().showErrorMessage('Something went wrong.');
      debugPrint(e.toString());
    }
  }
}

import 'package:bookcompanion/Utils/snackbar_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Homepage/View/homepage.dart';
import '../../Utils/progress_indicator_handler.dart';
import '../../config.dart';

class LoginBloc {
  Future<void> loginUser(String email, String password) async {
    try {
      ProgressIndicatorHandler().addCircularProgressIndicator();

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ProgressIndicatorHandler().removeLoadingIndicator();
      Navigator.push(
        CustomKey.navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        SnackBarHandler().showErrorMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        SnackBarHandler()
            .showErrorMessage('Wrong password provided for that user.');
      }
    }
  }
}

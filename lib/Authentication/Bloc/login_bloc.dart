import 'package:bookcompanion/Utils/snackbar_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<void> signInWithGoogle() async {
    await GoogleSignIn().signOut();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    ProgressIndicatorHandler().addCircularProgressIndicator();
    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .set({
      'email': userCredential.user?.email,
      'name': userCredential.user?.displayName,
      'selected_profile': '',
      'created_at': DateTime.now().toUtc().toString(),
    });
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .collection('profiles')
          .where(
            'email',
            isEqualTo: userCredential.user?.email,
          )
          .get()
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .collection('profiles')
            .doc(value.docs[0].id)
            .set({
          'nick_name': userCredential.user?.displayName,
          'email': userCredential.user?.email,
          'profile_url': userCredential.user?.photoURL,
          'created_at': DateTime.now().toUtc().toString(),
          'modified_at': DateTime.now().toUtc().toString(),
        });
      });
    } catch (e) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .collection('profiles')
          .doc()
          .set({
        'nick_name': userCredential.user?.displayName,
        'email': userCredential.user?.email,
        'profile_url': userCredential.user?.photoURL,
        'created_at': DateTime.now().toUtc().toString(),
        'modified_at': DateTime.now().toUtc().toString(),
      });
    }

    ProgressIndicatorHandler().removeLoadingIndicator();
    Navigator.push(
      CustomKey.navigatorKey.currentState!.context,
      MaterialPageRoute(
        builder: (context) => const Homepage(),
      ),
    );
  }
}

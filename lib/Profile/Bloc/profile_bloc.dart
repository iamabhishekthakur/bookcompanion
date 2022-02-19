import 'package:bookcompanion/Profile/Models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final PublishSubject<Profile> _profileDataPublisher =
      PublishSubject<Profile>();
  Stream<Profile> get profileData => _profileDataPublisher.stream;
  Future<void> fetchUserProfile() async {
    List<Profile> profileList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('profiles')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        profileList.add(
          Profile.fromJson(
            doc.data(),
          ),
        );
      }
    });
    _profileDataPublisher.sink.add(profileList.first);
  }

  Future<void> uploadProfilePicture(String profileUrl) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('profiles')
        .get()
        .then((value) async {
      // This logic will change when multiple profile support will be added
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('profiles')
          .doc(value.docs.first.id)
          .update({
        'profile_url': profileUrl,
        'modified_at': DateTime.now().toUtc().toString(),
      });
      profileBloc.fetchUserProfile();
    });
  }

  void dispose() {
    _profileDataPublisher.close();
  }
}

final profileBloc = ProfileBloc();

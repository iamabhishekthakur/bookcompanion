import 'package:bookcompanion/Profile/Models/profile.dart';
import 'package:bookcompanion/Utils/shared_preference_handler.dart';
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
          Profile(
            id: doc.id,
            nickName: doc.get('nick_name'),
            email: doc.get('email'),
            profileUrl: doc.get('profile_url'),
            modifiedAt: doc.get('modified_at'),
            createdAt: doc.get('created_at'),
          ),
        );
      }
    });
    if (profileList.isNotEmpty) {
      _profileDataPublisher.sink.add(profileList.first);
      sharedPreferenceHandler.setSelectedProfileID(profileList.first.id);
    }
  }

  Future<void> uploadProfilePicture(String profileUrl) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('profiles')
        .doc(await sharedPreferenceHandler.getSelectedProfileID())
        .update({
      'profile_url': profileUrl,
      'modified_at': DateTime.now().toUtc().toString(),
    });
    profileBloc.fetchUserProfile();
  }

  void dispose() {
    _profileDataPublisher.close();
  }
}

final profileBloc = ProfileBloc();

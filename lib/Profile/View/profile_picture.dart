import 'package:bookcompanion/Profile/Models/profile.dart';
import 'package:bookcompanion/Profile/View/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Authentication/View/login.dart';
import '../../Utils/color_constants.dart';
import '../Bloc/profile_bloc.dart';

class ProfilePictureView extends StatefulWidget {
  const ProfilePictureView({Key? key}) : super(key: key);

  @override
  _ProfilePictureViewState createState() => _ProfilePictureViewState();
}

class _ProfilePictureViewState extends State<ProfilePictureView> {
  @override
  void initState() {
    profileBloc.fetchUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges().asBroadcastStream(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.data == null) {
            return ElevatedButton(
              style: ButtonStyle(
                maximumSize: MaterialStateProperty.all(
                  const Size(
                    200,
                    50,
                  ),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return StreamBuilder(
                stream: profileBloc.profileData,
                builder: (context, AsyncSnapshot<Profile> snapshot) {
                  return IconButton(
                    icon: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          snapshot.data?.profileUrl ?? '',
                          fit: BoxFit.fill,
                          errorBuilder: (context, object, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileView(),
                        ),
                      );
                    },
                  );
                });
          }
        });
  }
}

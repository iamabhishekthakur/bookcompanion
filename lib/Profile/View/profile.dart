import 'dart:io';
import 'dart:typed_data';

import 'package:bookcompanion/Authentication/View/login.dart';
import 'package:bookcompanion/Profile/Bloc/profile_bloc.dart';
import 'package:bookcompanion/Profile/Models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../Homepage/Bloc/last_reading_bloc.dart';
import '../../Utils/color_constants.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: greyColor,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges().asBroadcastStream(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.data == null) {
            return const LoginRequiredView();
          } else {
            return const LoggedInView();
          }
        },
      ),
    );
  }
}

class LoggedInView extends StatefulWidget {
  const LoggedInView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoggedInView> createState() => _LoggedInViewState();
}

class _LoggedInViewState extends State<LoggedInView> {
  double fileUploadProgress = 0.0;

  @override
  void initState() {
    profileBloc.fetchUserProfile();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: profileBloc.profileData,
        builder: (context, AsyncSnapshot<Profile> snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                InkWell(
                  onTap: () async {
                    XFile? selectedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (selectedImage != null) {
                      File file = File(selectedImage.path);
                      Uint8List fileBytes = file.readAsBytesSync();
                      Reference firebaseStorageRef =
                          FirebaseStorage.instance.ref().child(
                                'profile_pictures/${file.path.split('/').last}',
                              );
                      UploadTask uploadTask =
                          firebaseStorageRef.putData(fileBytes);
                      uploadTask.snapshotEvents.listen((event) {
                        setState(() {
                          fileUploadProgress =
                              event.bytesTransferred.toDouble() /
                                  event.totalBytes.toDouble();
                        });
                      }).onError((error) {
                        // do something to handle error
                      });
                      uploadTask.whenComplete(() async {
                        String profileUrl =
                            await firebaseStorageRef.getDownloadURL();
                        profileBloc.uploadProfilePicture(profileUrl);
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                        bottom: Radius.circular(10),
                      ),
                    ),
                    child: Image.network(
                      snapshot.data!.profileUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, object, stackTrace) =>
                          const SizedBox(),
                    ),
                  ),
                ),
                (fileUploadProgress != 0.0)
                    ? LinearProgressIndicator(
                        value: fileUploadProgress,
                        color: Theme.of(context).primaryColor,
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  snapshot.data!.nickName.replaceAll(' ', '\n').toString(),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data!.email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 107,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
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
                    lastReadingBloc.fetchLastReadingDetail();
                    profileBloc.fetchUserProfile();
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text(
                    'LOGOUT',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            );
          }
        });
  }
}

class LoginRequiredView extends StatelessWidget {
  const LoginRequiredView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        SvgPicture.asset(
          'assets/images/not_logged_in.svg',
          height: 300,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Login\nRequired',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'You are not logged in.\nPlease login to manage your profile.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 107,
        ),
        ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
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
            'LOGIN',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

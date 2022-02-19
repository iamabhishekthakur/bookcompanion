import 'package:bookcompanion/AddBook/View/add_book.dart';
import 'package:bookcompanion/Homepage/View/public_library.dart';
import 'package:bookcompanion/Profile/Bloc/profile_bloc.dart';
import 'package:bookcompanion/Profile/Models/profile.dart';
import 'package:bookcompanion/Profile/View/profile_picture.dart';
import 'package:flutter/material.dart';

import '../../Utils/color_constants.dart';
import 'last_reading_view.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    profileBloc.fetchUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: const ProfilePictureView(),
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 120.0,
              actions: [
                IconButton(
                  visualDensity: VisualDensity.comfortable,
                  icon: CircleAvatar(
                    backgroundColor: greyColor,
                    child: const Icon(
                      Icons.add_circle_outline_outlined,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddBook(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 20),
                title: StreamBuilder(
                    stream: profileBloc.profileData,
                    builder: (context, AsyncSnapshot<Profile> snapshot) {
                      return Text(
                        'Hey, ${snapshot.data != null ? snapshot.data!.nickName.split(' ').first : 'Stranger'}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
              ),
            ),
            const SliverToBoxAdapter(
              child: PublicLibrary(),
            ),
          ],
        ),
        floatingActionButton: const LastReadingContinueView(),
      ),
    );
  }
}

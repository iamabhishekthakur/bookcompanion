import 'package:bookcompanion/AddBook/View/add_book.dart';
import 'package:bookcompanion/Homepage/View/my_library.dart';
import 'package:bookcompanion/Homepage/View/my_readings.dart';
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

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin {
  String userNickName = '';
  @override
  void initState() {
    profileBloc.fetchUserProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              pinned: false,
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
                titlePadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                centerTitle: false,
                title: StreamBuilder(
                    stream: profileBloc.profileData,
                    builder: (context, AsyncSnapshot<Profile> snapshot) {
                      if (snapshot.data != null) {
                        userNickName = snapshot.data!.nickName.split(' ').first;
                      }
                      return Text(
                        'Hey, ${userNickName.isNotEmpty ? userNickName : 'Stranger'}',
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
            SliverToBoxAdapter(
              child: userNickName.isNotEmpty
                  ? const MyReadings()
                  : Container(
                      margin:
                          const EdgeInsets.only(left: 50, right: 50, top: 100),
                      child: const Text(
                        'Login to start managing your book reading.',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                        ),
                      ),
                    ),
            ),
            SliverToBoxAdapter(
              child: userNickName.isNotEmpty
                  ? const MyLibrary()
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: const Text(
                        'Add book and keep it private, so that it will appear for you only.',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                        ),
                      ),
                    ),
            ),
          ],
        ),
        floatingActionButton: const LastReadingContinueView(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

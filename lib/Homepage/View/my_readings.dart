import 'dart:math';

import 'package:bookcompanion/AddBook/Models/book.dart';
import 'package:bookcompanion/Homepage/Models/reading_status.dart';
import 'package:bookcompanion/Utils/color_constants.dart';
import 'package:flutter/material.dart';

import '../../Reading/View/reading_view.dart';
import '../../Utils/string_constants.dart';
import '../Bloc/my_reading_bloc.dart';

class MyReadings extends StatefulWidget {
  const MyReadings({Key? key}) : super(key: key);

  @override
  _MyReadingsState createState() => _MyReadingsState();
}

class _MyReadingsState extends State<MyReadings> {
  @override
  void initState() {
    myReadingBloc.fetchYourReadingBookStatus();
    super.initState();
  }

  @override
  void dispose() {
    myReadingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: myReadingBloc.yourReadingBookData,
        builder: (context, AsyncSnapshot<List<ReadingStatus>> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<ReadingStatus> data = snapshot.data!;
            return Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'My Readings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 270,
                    child: ListView.separated(
                      itemCount: data.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          ReadingStatus readingStatusData = data[index];

                          Book bookData = Book(
                            id: readingStatusData.id,
                            title: readingStatusData.title,
                            author: readingStatusData.author,
                            fileUrl: readingStatusData.fileUrl,
                            categoryTitle: '',
                            addedByUserId: '',
                            insertTs: '',
                            keepBookPrivate: false,
                            coverPictureUrl: '',
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadingView(
                                bookData: bookData,
                                initialPage: readingStatusData.currentPage,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: 160,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: greyColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Image.network(
                                  listOfCoverPicture[Random().nextInt(10)],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index].title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    data[index].author,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 15,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}

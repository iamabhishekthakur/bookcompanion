import 'package:bookcompanion/AddBook/Models/book.dart';
import 'package:bookcompanion/Homepage/Bloc/last_reading_bloc.dart';
import 'package:bookcompanion/Homepage/Models/reading_status.dart';
import 'package:flutter/material.dart';

import '../../Reading/View/reading_view.dart';

class LastReadingContinueView extends StatefulWidget {
  const LastReadingContinueView({
    Key? key,
  }) : super(key: key);

  @override
  State<LastReadingContinueView> createState() =>
      _LastReadingContinueViewState();
}

class _LastReadingContinueViewState extends State<LastReadingContinueView> {
  @override
  void initState() {
    lastReadingBloc.fetchLastReadingDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: lastReadingBloc.lastReadingData,
      builder: (context, AsyncSnapshot<ReadingStatus> snapshot) {
        if (snapshot.data != null) {
          ReadingStatus readingStatusData = snapshot.data!;
          return InkWell(
            onTap: () {
              Book bookData = Book(
                id: readingStatusData.id,
                title: readingStatusData.title,
                author: readingStatusData.author,
                fileUrl: readingStatusData.fileUrl,
                categoryTitle: '',
                addedByUserId: '',
                insertTs: '',
                keepBookPrivate: false,
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
            highlightColor: Colors.white,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.play_circle_fill,
                    size: 45,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Continue reading',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(readingStatusData.currentPage + 1)} / ${readingStatusData.totalPage}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

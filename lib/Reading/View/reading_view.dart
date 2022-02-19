import 'dart:async';

import 'package:bookcompanion/AddBook/Models/book.dart';
import 'package:bookcompanion/Homepage/Bloc/last_reading_bloc.dart';
import 'package:bookcompanion/Homepage/Bloc/my_reading_bloc.dart';
import 'package:bookcompanion/Homepage/Models/reading_status.dart';
import 'package:bookcompanion/Reading/Bloc/reading_bloc.dart';
import 'package:bookcompanion/Utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class ReadingView extends StatefulWidget {
  const ReadingView(
      {Key? key, required this.bookData, required this.initialPage})
      : super(key: key);
  final Book bookData;
  final int initialPage;
  @override
  _ReadingViewState createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView> {
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  final StreamController<String> _pageCountController =
      StreamController<String>();
  int currentPage = 0;
  int numberOfPages = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: greyColor,
        ),
        backgroundColor: greyColor,
        title: InkWell(
          onTap: () {
            ReadingStatus readingStatus = ReadingStatus(
              title: widget.bookData.title,
              author: widget.bookData.author,
              modifiedAt: DateTime.now().toUtc().toString(),
              currentPage: currentPage,
              id: widget.bookData.id,
              totalPage: numberOfPages,
              fileUrl: widget.bookData.fileUrl,
            );
            lastReadingBloc.publishLastReadingDetail(readingStatus);
            readingBloc.updateReadingStatusOfBook(readingStatus);
            myReadingBloc.fetchYourReadingBookStatus();
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.2,
                  ),
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bookData.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.bookData.author,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.2,
                  ),
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder(
                    stream: _pageCountController.stream,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return Text(
                        snapshot.data ?? 'Loading',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      );
                    }),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
      body: PDF(
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        defaultPage: widget.initialPage,
        onPageChanged: (int? current, int? total) {
          currentPage = current ?? 0;
          numberOfPages = total ?? 0;
          _pageCountController.add('${current! + 1} - $total');
        },
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          currentPage = await pdfViewController.getCurrentPage() ?? 0;
          final int? pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage + 1} - $pageCount');
        },
      ).fromUrl(widget.bookData.fileUrl),
    );
  }
}

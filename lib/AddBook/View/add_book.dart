import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bookcompanion/AddBook/Bloc/add_book_bloc.dart';
import 'package:bookcompanion/AddBook/Models/book.dart';
import 'package:bookcompanion/Utils/color_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Utils/snackbar_handler.dart';
import '../../Utils/string_constants.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final AddBookBloc _addBookBloc = AddBookBloc();
  final _formKey = GlobalKey<FormState>();

  final _book = Book(
    title: '',
    author: '',
    fileUrl: '',
    categoryTitle: '',
    addedByUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
    insertTs: '',
    keepBookPrivate: false,
    id: '',
    coverPictureUrl: listOfCoverPicture[Random().nextInt(10)],
  );

  String selectedFileName = '';
  double fileUploadProgress = 0.0;
  String? selectedBookGenres;

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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              SvgPicture.asset(
                'assets/images/primary_logo.svg',
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Upload\nBook',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              selectedFileName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );

                                  if (result != null) {
                                    File file = File(result.files.single.path!);
                                    setState(() {
                                      selectedFileName = result.names.first!;
                                    });
                                    Uint8List fileBytes =
                                        file.readAsBytesSync();
                                    Reference firebaseStorageRef =
                                        FirebaseStorage.instance
                                            .ref()
                                            .child('books/$selectedFileName');
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
                                      _book.fileUrl = await firebaseStorageRef
                                          .getDownloadURL();
                                    });
                                  } else {
                                    // User canceled the picker
                                  }
                                },
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(
                                  Icons.cloud_upload_outlined,
                                ),
                              ),
                              const Text(
                                'Choose file',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    LinearProgressIndicator(
                      value: fileUploadProgress,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    color: greyColorDark,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 84,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: 'Book name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter book name';
                          }
                          return null;
                        },
                        onChanged: (typedString) {
                          _book.title = typedString;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.person_outlined,
                    color: greyColorDark,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 84,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: 'Author name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter author name';
                          }
                          return null;
                        },
                        onChanged: (typedString) {
                          _book.author = typedString;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: _addBookBloc.fetchBookGenres(),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  var items = snapshot.data ?? [];
                  return Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        color: greyColorDark,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 84,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: TextFormField(
                            enabled: true,
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: selectedBookGenres ?? '',
                              ),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: 'Book genre',
                              suffixIcon: SizedBox(
                                width: 150,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    // Down Arrow Icon
                                    value: null,
                                    selectedItemBuilder: (context) =>
                                        [const SizedBox()],
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: greyColorDark,
                                    ),
                                    // Array list of items
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedBookGenres = newValue!;
                                        _book.categoryTitle = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select genre';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 44,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 84,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: InkWell(
                        radius: 0,
                        highlightColor: Colors.white,
                        onTap: () {
                          setState(() {
                            _book.keepBookPrivate = !_book.keepBookPrivate;
                          });
                        },
                        child: TextFormField(
                          enabled: false,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Make this book private',
                            hintStyle: TextStyle(
                              color: greyColorDark,
                            ),
                            suffixIcon: Switch(
                              onChanged: (newValue) {
                                setState(() {
                                  _book.keepBookPrivate =
                                      !_book.keepBookPrivate;
                                });
                              },
                              value: _book.keepBookPrivate,
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  if (_book.fileUrl.isNotEmpty) {
                    if (_formKey.currentState!.validate()) {
                      _addBookBloc.uploadBookData(_book);
                    }
                  } else {
                    SnackBarHandler().showErrorMessage(
                      'Select / Wait for upload',
                    );
                  }
                },
                child: const Text(
                  'ADD BOOK',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

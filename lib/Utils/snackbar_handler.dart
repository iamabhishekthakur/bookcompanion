import 'package:flutter/material.dart';

import '../config.dart';

class SnackBarHandler {
  void showListOfErrorMessages(List<String> messages) {
    CustomKey.scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            messages.length,
            (index) => Text(
              '${index + 1} . ${messages[index]}.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Theme.of(
                  CustomKey.scaffoldMessengerKey.currentState!.context,
                ).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showErrorMessage(String message) {
    CustomKey.scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Theme.of(
              CustomKey.scaffoldMessengerKey.currentState!.context,
            ).primaryColor,
          ),
        ),
      ),
    );
  }

  void showSuccessMessage(String message) {
    CustomKey.scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Theme.of(
              CustomKey.scaffoldMessengerKey.currentState!.context,
            ).primaryColor,
          ),
        ),
      ),
    );
  }
}

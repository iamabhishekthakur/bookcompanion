import 'package:bookcompanion/config.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorHandler {
  Future addCircularProgressIndicator() => showDialog(
        context: CustomKey.navigatorKey.currentState!.context,
        builder: (_) => Center(
          child: CircularProgressIndicator(
            color: Theme.of(CustomKey.navigatorKey.currentState!.context)
                .primaryColor,
          ),
        ),
      );
  void removeLoadingIndicator() =>
      Navigator.pop(CustomKey.navigatorKey.currentState!.context);
}

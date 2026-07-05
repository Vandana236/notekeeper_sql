import 'package:flutter/material.dart';

class AppNavigator {

  /// PUSH
  static Future push(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  /// PUSH REPLACEMENT
  static Future pushReplacement(
      BuildContext context,
      Widget page,
      ) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  /// POP
  static void pop(BuildContext context) {
    Navigator.pop(context, true);
  }
}
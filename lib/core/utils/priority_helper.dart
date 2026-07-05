import 'package:flutter/material.dart';

class PriorityHelper {

  /// PRIORITY LIST
  static List<String> priorities = [
    'High',
    'Low',
  ];

  /// PRIORITY COLOR
  static Color getPriorityColor(
      int priority,
      ) {

    switch (priority) {

      case 1:
        return Colors.red;

      case 2:
        return Colors.yellow;

      default:
        return Colors.grey;
    }
  }

  /// PRIORITY ICON
  static Icon getPriorityIcon(
      int priority,
      ) {

    switch (priority) {

      case 1:
        return const Icon(
          Icons.play_arrow,
          color: Colors.white,
        );

      case 2:
        return const Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
        );

      default:
        return const Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
        );
    }
  }

  /// INT TO STRING
  static String getPriorityAsString(
      int priority,
      ) {

    switch (priority) {

      case 1:
        return priorities[0];

      case 2:
        return priorities[1];

      default:
        return priorities[1];
    }
  }

  /// STRING TO INT
  static int updatePriorityAsInt(
      String value,
      ) {

    switch (value) {

      case 'High':
        return 1;

      case 'Low':
        return 2;

      default:
        return 2;
    }
  }

  /// SNACKBAR
  static void showSnackBar(
      BuildContext context,
      String message,
      ) {

    final snackBar = SnackBar(
      content: Text(message),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar);
  }
}
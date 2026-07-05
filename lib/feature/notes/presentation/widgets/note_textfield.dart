import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {

  final String hintText;
  final int maxLines;
  final TextEditingController controller;

  const NoteTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
      maxLines: maxLines,

      decoration: InputDecoration(
        hintText: hintText,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
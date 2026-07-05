import 'package:flutter/material.dart';

import '../../../../core/utils/priority_helper.dart';

class NoteDropdown extends StatelessWidget {

  final String selectedPriority;

  final Function(String?) onChanged;

  const NoteDropdown({
    super.key,
    required this.selectedPriority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField<String>(

      value: selectedPriority,

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
      ),

      items:
      PriorityHelper.priorities
          .map((value) {

        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );

      }).toList(),

      onChanged: onChanged,
    );
  }
}
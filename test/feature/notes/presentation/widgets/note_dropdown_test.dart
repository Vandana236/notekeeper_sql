import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notekeeper_app_with_sqlite/core/utils/priority_helper.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/presentation/widgets/note_dropdown.dart';

void main() {
  testWidgets(
    'NoteDropdown should display selected priority',
    (tester) async {
      // Arrange
      final priorities = PriorityHelper.priorities;
      final selectedPriority = priorities.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteDropdown(
              selectedPriority: selectedPriority,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.byType(NoteDropdown),
        findsOneWidget,
      );

      expect(
        find.byType(DropdownButtonFormField<String>),
        findsOneWidget,
      );

      expect(
        find.text(selectedPriority),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'NoteDropdown should show all priority options',
    (tester) async {
      // Arrange
      final priorities = PriorityHelper.priorities;
      final selectedPriority = priorities.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteDropdown(
              selectedPriority: selectedPriority,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(
        find.byType(DropdownButtonFormField<String>),
      );

      await tester.pumpAndSettle();

      // Assert
      for (final priority in priorities) {
        expect(
          find.text(priority),
          findsWidgets,
        );
      }
    },
  );

  testWidgets(
    'NoteDropdown should call onChanged when another priority is selected',
    (tester) async {
      // Arrange
      final priorities = PriorityHelper.priorities;

      // Need at least 2 priorities for this test
      expect(
        priorities.length,
        greaterThan(1),
      );

      final selectedPriority = priorities.first;
      final newPriority = priorities[1];

      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteDropdown(
              selectedPriority: selectedPriority,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(
        find.byType(DropdownButtonFormField<String>),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text(newPriority).last,
      );

      await tester.pumpAndSettle();

      // Assert
      expect(
        changedValue,
        newPriority,
      );
    },
  );
}
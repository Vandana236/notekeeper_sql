import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/presentation/widgets/note_button.dart';

void main() {
  testWidgets('NoteButton should display text', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteButton(
            text: 'Save',
            onPressed: () {},
            backgroundColor: Colors.deepPurple,
          ),
        ),
      ),
    );

    // Assert
    expect(
      find.text('Save'),
      findsOneWidget,
    );
  });

  testWidgets('NoteButton should call onPressed when tapped', (tester) async {
    // Arrange
    bool isPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteButton(
            text: 'Save',
            onPressed: () {
              isPressed = true;
            },
            backgroundColor: Colors.deepPurple,
          ),
        ),
      ),
    );

    // Act
    await tester.tap(
      find.text('Save'),
    );

    await tester.pump();

    // Assert
    expect(isPressed, true);
  });

  testWidgets('NoteButton should contain ElevatedButton', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteButton(
            text: 'Save',
            onPressed: () {},
            backgroundColor: Colors.deepPurple,
          ),
        ),
      ),
    );

    // Assert
    expect(
      find.byType(NoteButton),
      findsOneWidget,
    );

    expect(
      find.byType(ElevatedButton),
      findsOneWidget,
    );
  });
}
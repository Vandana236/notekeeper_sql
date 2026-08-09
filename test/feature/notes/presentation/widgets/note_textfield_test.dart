import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/presentation/widgets/note_textfield.dart';

void main() {
  testWidgets('NoteTextField should display TextField', (tester) async {
    // Arrange
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteTextField(
            hintText: 'Title',
            controller: controller,
          ),
        ),
      ),
    );

    // Assert
    expect(
      find.byType(NoteTextField),
      findsOneWidget,
    );

    expect(
      find.byType(TextField),
      findsOneWidget,
    );

    controller.dispose();
  });

  testWidgets('NoteTextField should display hint text', (tester) async {
    // Arrange
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteTextField(
            hintText: 'Enter Title',
            controller: controller,
          ),
        ),
      ),
    );

    // Assert
    expect(
      find.text('Enter Title'),
      findsOneWidget,
    );

    controller.dispose();
  });

  testWidgets('NoteTextField should accept text input', (tester) async {
    // Arrange
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteTextField(
            hintText: 'Title',
            controller: controller,
          ),
        ),
      ),
    );

    // Act
    await tester.enterText(
      find.byType(TextField),
      'Flutter',
    );

    // Assert
    expect(
      controller.text,
      'Flutter',
    );

    controller.dispose();
  });

  testWidgets('NoteTextField should use given maxLines', (tester) async {
    // Arrange
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteTextField(
            hintText: 'Description',
            maxLines: 4,
            controller: controller,
          ),
        ),
      ),
    );

    // Act
    final textField = tester.widget<TextField>(
      find.byType(TextField),
    );

    // Assert
    expect(
      textField.maxLines,
      4,
    );

    controller.dispose();
  });
}
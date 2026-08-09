import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:notekeeper_app_with_sqlite/feature/notes/data/datasource/note_local_datasource.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/data/models/notes.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/presentation/pages/add_edit_note_page.dart';

class MockNoteLocalDataSource extends Mock
    implements NoteLocalDataSource {}

void main() {
  late MockNoteLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(
      NoteModel(
        'dummy',
        'dummy',
        1,
        'dummy',
      ),
    );
  });

  setUp(() {
    mockDataSource = MockNoteLocalDataSource();
  });

  group('AddEditNotePage Test', () {

    // --------------------------------------------------
    // ADD MODE
    // --------------------------------------------------

    testWidgets(
      'should display Add Note screen',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEditNotePage(
              dataSource: mockDataSource,
            ),
          ),
        );

        expect(
          find.text('Add Note'),
          findsOneWidget,
        );

        expect(
          find.text('Title'),
          findsOneWidget,
        );

        expect(
          find.text('Description'),
          findsOneWidget,
        );

        expect(
          find.text('Save'),
          findsOneWidget,
        );

        expect(
          find.text('Delete'),
          findsNothing,
        );
      },
    );

    // --------------------------------------------------
    // EMPTY TITLE
    // --------------------------------------------------

    testWidgets(
      'should show validation when title is empty',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: AddEditNotePage(
              dataSource: mockDataSource,
            ),
          ),
        );

        await tester.tap(
          find.text('Save'),
        );

        await tester.pump();

        expect(
          find.text('Please Enter Title'),
          findsOneWidget,
        );

        verifyNever(
          () => mockDataSource.insertNote(any()),
        );
      },
    );

    // --------------------------------------------------
    // SAVE NOTE
    // --------------------------------------------------

    testWidgets(
      'should save note when title is entered',
      (tester) async {
        // Arrange
        when(
          () => mockDataSource.insertNote(any()),
        ).thenAnswer(
          (_) async => 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: AddEditNotePage(
              dataSource: mockDataSource,
            ),
          ),
        );

        // Act
        await tester.enterText(
          find.byType(TextField).first,
          'Flutter',
        );

        await tester.enterText(
          find.byType(TextField).last,
          'Learning Flutter',
        );

        await tester.tap(
          find.text('Save'),
        );

        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockDataSource.insertNote(any()),
        ).called(1);
      },
    );

    // --------------------------------------------------
    // EDIT MODE
    // --------------------------------------------------

    testWidgets(
      'should display Edit Note screen with existing note',
      (tester) async {
        // Arrange
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 0;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: AddEditNotePage(
              note: note,
              dataSource: mockDataSource,
            ),
          ),
        );

        // Assert
        expect(
          find.text('Edit Note'),
          findsOneWidget,
        );

        expect(
          find.text('Delete'),
          findsOneWidget,
        );

        expect(
          find.text('Flutter'),
          findsOneWidget,
        );

        expect(
          find.text('Learning Flutter'),
          findsOneWidget,
        );
      },
    );

    // --------------------------------------------------
    // UPDATE NOTE
    // --------------------------------------------------

    testWidgets(
      'should update note when existing note is edited',
      (tester) async {
        // Arrange
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 0;

        when(
          () => mockDataSource.updateNote(any()),
        ).thenAnswer(
          (_) async => 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: AddEditNotePage(
              note: note,
              dataSource: mockDataSource,
            ),
          ),
        );

        // Act
        await tester.enterText(
          find.byType(TextField).first,
          'Flutter Updated',
        );

        await tester.enterText(
          find.byType(TextField).last,
          'Updated Description',
        );

        await tester.tap(
          find.text('Save'),
        );

        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockDataSource.updateNote(any()),
        ).called(1);

        verifyNever(
          () => mockDataSource.insertNote(any()),
        );
      },
    );

    // --------------------------------------------------
    // DELETE NOTE
    // --------------------------------------------------

    testWidgets(
      'should delete note when Delete button is pressed',
      (tester) async {
        // Arrange
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 0;

        when(
          () => mockDataSource.deleteNote(1),
        ).thenAnswer(
          (_) async => 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: AddEditNotePage(
              note: note,
              dataSource: mockDataSource,
            ),
          ),
        );

        // Act
        await tester.tap(
          find.text('Delete'),
        );

        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockDataSource.deleteNote(1),
        ).called(1);
      },
    );

    // --------------------------------------------------
    // DELETE BUTTON SHOULD NOT BE SHOWN IN ADD MODE
    // --------------------------------------------------

    testWidgets(
      'should not show Delete button in add mode',
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: AddEditNotePage(
              dataSource: mockDataSource,
            ),
          ),
        );

        // Assert
        expect(
          find.text('Delete'),
          findsNothing,
        );

        verifyNever(
          () => mockDataSource.deleteNote(any()),
        );
      },
    );

    // --------------------------------------------------
    // EDIT MODE SHOULD SHOW EXISTING VALUES
    // --------------------------------------------------

    testWidgets(
      'should initialize text fields with existing note values',
      (tester) async {
        // Arrange
        final note = NoteModel.withId(
          5,
          'Dart',
          '25 July',
          2,
          'Learning Dart',
        );

        note.isSynced = 1;

        await tester.pumpWidget(
          MaterialApp(
            home: AddEditNotePage(
              note: note,
              dataSource: mockDataSource,
            ),
          ),
        );

        // Act
        final textFields = find.byType(TextField);

        final titleField =
            tester.widget<TextField>(textFields.first);

        final descriptionField =
            tester.widget<TextField>(textFields.last);

        // Assert
        expect(
          titleField.controller?.text,
          'Dart',
        );

        expect(
          descriptionField.controller?.text,
          'Learning Dart',
        );
      },
    );
  });
}
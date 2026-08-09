import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:notekeeper_app_with_sqlite/core/services/crashlytics_service.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/data/datasource/note_local_datasource.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/data/models/notes.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/presentation/pages/notes_list_page.dart';

class MockNoteLocalDataSource extends Mock
    implements NoteLocalDataSource {}

class MockCrashlyticsService extends Mock
    implements CrashlyticsService {}

void main() {
  late MockNoteLocalDataSource mockDataSource;
  late MockCrashlyticsService mockCrashlytics;

  // Mocktail fallback values
  setUpAll(() {
    // Required for any() with NoteModel
    registerFallbackValue(
      NoteModel(
        'dummy',
        'dummy',
        1,
        'dummy',
      ),
    );

    // Required for any() with StackTrace
    registerFallbackValue(
      StackTrace.current,
    );
  });

  setUp(() {
    mockDataSource = MockNoteLocalDataSource();
    mockCrashlytics = MockCrashlyticsService();
  });

  group('NotesListPage Test', () {

    // Your existing tests continue here...

    // --------------------------------------------------
    // EMPTY NOTES
    // --------------------------------------------------

    testWidgets(
      'should show No Notes Available when there are no notes',
      (tester) async {
        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('No Notes Available'),
          findsOneWidget,
        );

        expect(
          find.byType(ListView),
          findsNothing,
        );
      },
    );

    // --------------------------------------------------
    // DISPLAY NOTES
    // --------------------------------------------------

    testWidgets(
      'should display notes when notes are available',
      (tester) async {
        final notes = [
          NoteModel.withId(
            1,
            'Flutter',
            '20 July',
            1,
            'Learning Flutter',
          ),
          NoteModel.withId(
            2,
            'Dart',
            '21 July',
            2,
            'Learning Dart',
          ),
        ];

        notes[0].isSynced = 1;
        notes[1].isSynced = 0;

        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => notes,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(ListView),
          findsOneWidget,
        );

        expect(
          find.text('Flutter'),
          findsOneWidget,
        );

        expect(
          find.text('Dart'),
          findsOneWidget,
        );

        expect(
          find.text('20 July'),
          findsOneWidget,
        );

        expect(
          find.text('21 July'),
          findsOneWidget,
        );
      },
    );

    // --------------------------------------------------
    // GET NOTES
    // --------------------------------------------------

    testWidgets(
      'should call getNoteList when page is initialized',
      (tester) async {
        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        verify(
          () => mockDataSource.getNoteList(),
        ).called(1);
      },
    );

    // --------------------------------------------------
    // GET NOTES ERROR
    // --------------------------------------------------

    testWidgets(
      'should show error when getNoteList throws exception',
      (tester) async {
        final exception = Exception('Database error');
        // final stackTrace = StackTrace.current;

        when(
          () => mockDataSource.getNoteList(),
        ).thenThrow(exception);

        when(
          () => mockCrashlytics.recordError(
            any(),
            any(),
          ),
        ).thenAnswer(
          (_) async {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pump();

        expect(
          find.text('Failed to Load Notes'),
          findsOneWidget,
        );

        verify(
          () => mockDataSource.getNoteList(),
        ).called(1);

        verify(
          () => mockCrashlytics.recordError(
            any(),
            any(),
          ),
        ).called(1);
      },
    );

    // --------------------------------------------------
    // ADD BUTTON
    // --------------------------------------------------

    testWidgets(
      'should show Add button',
      (tester) async {
        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(FloatingActionButton),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.add),
          findsOneWidget,
        );
      },
    );

    // --------------------------------------------------
    // ADD NOTE NAVIGATION
    // --------------------------------------------------

    testWidgets(
      'should navigate to Add Note page when add button is pressed',
      (tester) async {
        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [],
        );

        when(
          () => mockDataSource.insertNote(any()),
        ).thenAnswer(
          (_) async => 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.byIcon(Icons.add),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Add Note'),
          findsOneWidget,
        );

        expect(
          find.text('Save'),
          findsOneWidget,
        );
      },
    );

    // --------------------------------------------------
    // ADD NOTE + RESULT TRUE
    // --------------------------------------------------

    testWidgets(
      'should return to NotesListPage after saving new note',
      (tester) async {
        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [],
        );

        when(
          () => mockDataSource.insertNote(any()),
        ).thenAnswer(
          (_) async => 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.byIcon(Icons.add),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Add Note'),
          findsOneWidget,
        );

        await tester.enterText(
          find.byType(TextField).first,
          'Flutter',
        );

        await tester.tap(
          find.text('Save'),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('No Notes Available'),
          findsOneWidget,
        );

        verify(
          () => mockDataSource.insertNote(any()),
        ).called(1);
      },
    );

    // --------------------------------------------------
    // CRASHLYTICS BUTTON
    // --------------------------------------------------

    testWidgets(
      'should show bug report button',
      (tester) async {
        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.byIcon(Icons.bug_report),
          findsOneWidget,
        );
      },
    );

    // --------------------------------------------------
    // SYNCED NOTE
    // --------------------------------------------------

    testWidgets(
      'should show cloud_done when note is synced',
      (tester) async {
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 1;

        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [note],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.byIcon(Icons.cloud_done),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.cloud_off),
          findsNothing,
        );
      },
    );

    // --------------------------------------------------
    // UNSYNCED NOTE
    // --------------------------------------------------

    testWidgets(
      'should show cloud_off when note is not synced',
      (tester) async {
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 0;

        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [note],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.byIcon(Icons.cloud_off),
          findsOneWidget,
        );

        expect(
          find.byIcon(Icons.cloud_done),
          findsNothing,
        );
      },
    );

    // --------------------------------------------------
    // EDIT NOTE NAVIGATION
    // --------------------------------------------------

    testWidgets(
      'should navigate to Edit Note page when note is tapped',
      (tester) async {
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 0;

        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [note],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Flutter'),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Edit Note'),
          findsOneWidget,
        );

        expect(
          find.text('Delete'),
          findsOneWidget,
        );
      },
    );

    // --------------------------------------------------
    // DELETE NOTE SUCCESS
    // --------------------------------------------------

    testWidgets(
      'should call deleteNote when delete button is pressed',
      (tester) async {
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 0;

        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [note],
        );

        when(
          () => mockDataSource.deleteNote(1),
        ).thenAnswer(
          (_) async => 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.byIcon(Icons.delete),
        );

        await tester.pumpAndSettle();

        verify(
          () => mockDataSource.deleteNote(1),
        ).called(1);
      },
    );

    // --------------------------------------------------
    // DELETE NOTE - RESULT ZERO
    // --------------------------------------------------

    testWidgets(
      'should not show success message when delete returns zero',
      (tester) async {
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 0;

        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [note],
        );

        when(
          () => mockDataSource.deleteNote(1),
        ).thenAnswer(
          (_) async => 0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.byIcon(Icons.delete),
        );

        await tester.pumpAndSettle();

        verify(
          () => mockDataSource.deleteNote(1),
        ).called(1);

        expect(
          find.text('Note Deleted Successfully'),
          findsNothing,
        );
      },
    );

    // --------------------------------------------------
    // DELETE NOTE ERROR
    // --------------------------------------------------

    testWidgets(
      'should show error when deleteNote throws exception',
      (tester) async {
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 0;

        final exception = Exception('Delete database error');

        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [note],
        );

        when(
          () => mockDataSource.deleteNote(1),
        ).thenThrow(exception);

        when(
          () => mockCrashlytics.recordError(
            any(),
            any(),
          ),
        ).thenAnswer(
          (_) async {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.byIcon(Icons.delete),
        );

        await tester.pump();

        expect(
          find.text('Failed to Delete Note'),
          findsOneWidget,
        );

        verify(
          () => mockDataSource.deleteNote(1),
        ).called(1);

        verify(
          () => mockCrashlytics.recordError(
            any(),
            any(),
          ),
        ).called(1);
      },
    );

    // --------------------------------------------------
    // EDIT NOTE - UPDATE
    // --------------------------------------------------

    testWidgets(
      'should update list after returning from edit page',
      (tester) async {
        final note = NoteModel.withId(
          1,
          'Flutter',
          '20 July',
          1,
          'Learning Flutter',
        );

        note.isSynced = 0;

        when(
          () => mockDataSource.getNoteList(),
        ).thenAnswer(
          (_) async => [note],
        );

        when(
          () => mockDataSource.updateNote(any()),
        ).thenAnswer(
          (_) async => 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: NotesListPage(
              dataSource: mockDataSource,
              crashlyticsService: mockCrashlytics,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Flutter'),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Edit Note'),
          findsOneWidget,
        );

        await tester.enterText(
          find.byType(TextField).first,
          'Flutter Updated',
        );

        await tester.tap(
          find.text('Save'),
        );

        await tester.pumpAndSettle();

        verify(
          () => mockDataSource.updateNote(any()),
        ).called(1);

        expect(
          find.text('Notes'),
          findsOneWidget,
        );
      },
    );
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:notekeeper_app_with_sqlite/feature/notes/data/datasource/note_local_datasource.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/data/models/notes.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/data/note_repositories_imp.dart'; 
import 'package:notekeeper_app_with_sqlite/feature/notes/domain/entities/note.dart';

class MockNoteLocalDataSource extends Mock
    implements NoteLocalDataSource {}

void main() {
  late MockNoteLocalDataSource mockDataSource;
  late NoteRepositoryImpl repository;

  // IMPORTANT
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
    repository = NoteRepositoryImpl(mockDataSource);
  });

  group('NoteRepositoryImpl Test', () {

    // ADD NOTE
    test('addNote should call insertNote on data source', () async {
      // Arrange
      final note = Note(
        title: 'Flutter',
        description: 'Learning Flutter',
        date: '20 July',
        priority: 1,
      );

      when(
        () => mockDataSource.insertNote(any()),
      ).thenAnswer(
        (_) async => 1,
      );

      // Act
      final result = await repository.addNote(note);

      // Assert
      expect(result, 1);

      verify(
        () => mockDataSource.insertNote(any()),
      ).called(1);
    });

    // GET NOTES
    test('getNotes should return notes from data source', () async {
      // Arrange
      final noteModel = NoteModel(
        'Flutter',
        '20 July',
        1,
        'Learning Flutter',
      );

      noteModel.isSynced = 0;

      when(
        () => mockDataSource.getNoteList(),
      ).thenAnswer(
        (_) async => [noteModel],
      );

      // Act
      final result = await repository.getNotes();

      // Assert
      expect(result.length, 1);
      expect(result.first.title, 'Flutter');
      expect(result.first.description, 'Learning Flutter');
      expect(result.first.date, '20 July');
      expect(result.first.priority, 1);

      verify(
        () => mockDataSource.getNoteList(),
      ).called(1);
    });

    // UPDATE NOTE
    test('updateNote should call updateNote on data source', () async {
      // Arrange
      final note = Note(
        id: 1,
        title: 'Flutter Updated',
        description: 'Advanced Flutter',
        date: '21 July',
        priority: 2,
      );

      when(
        () => mockDataSource.updateNote(any()),
      ).thenAnswer(
        (_) async => 1,
      );

      // Act
      final result = await repository.updateNote(note);

      // Assert
      expect(result, 1);

      verify(
        () => mockDataSource.updateNote(any()),
      ).called(1);
    });

    // DELETE NOTE
    test('deleteNote should call deleteNote on data source', () async {
      // Arrange
      when(
        () => mockDataSource.deleteNote(1),
      ).thenAnswer(
        (_) async => 1,
      );

      // Act
      final result = await repository.deleteNote(1);

      // Assert
      expect(result, 1);

      verify(
        () => mockDataSource.deleteNote(1),
      ).called(1);
    });
  });
}
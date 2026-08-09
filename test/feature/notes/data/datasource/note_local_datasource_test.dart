import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:notekeeper_app_with_sqlite/feature/notes/data/datasource/note_local_datasource.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/data/models/notes.dart';

void main() {
  late Database database;
  late NoteLocalDataSource dataSource;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    database = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE note_table(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              description TEXT,
              priority INTEGER,
              date TEXT,
              isSynced INTEGER
            )
          ''');
        },
      ),
    );

    dataSource = NoteLocalDataSource(
      database: database,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('NoteLocalDataSource Test', () {
    
     // 1. INSERT
    test('insertNote should insert note', () async {
      // Arrange
      final note = NoteModel(
        "Flutter",
        "20 July",
        1,
        "Learning Flutter",
      );

      note.isSynced = 0;

      // Act
      final result = await dataSource.insertNote(note);

      // Assert
      expect(result, greaterThan(0));
    });
    
     // 2. GET LIST
    test('getNoteList should return inserted notes', () async {
      // Arrange
      final note = NoteModel(
        "Flutter",
        "20 July",
        1,
        "Learning Flutter",
      );

      note.isSynced = 0;

      await dataSource.insertNote(note);

      // Act
      final result = await dataSource.getNoteList();

      // Assert
      expect(result.length, 1);
      expect(result.first.title, "Flutter");
      expect(result.first.description, "Learning Flutter");
    });
     
     // 3. UPDATE
    test('updateNote should update existing note', () async {
      // Arrange
      final note = NoteModel(
        "Flutter",
        "20 July",
        1,
        "Learning Flutter",
      );

      note.isSynced = 0;

      final id = await dataSource.insertNote(note);

      final updatedNote = NoteModel.withId(
        id,
        "Flutter Updated",
        "21 July",
        2,
        "Advanced Flutter",
      );

      updatedNote.isSynced = 1;

      // Act
      final result = await dataSource.updateNote(updatedNote);

      // Assert
      expect(result, 1);

      final notes = await dataSource.getNoteList();

      expect(notes.first.title, "Flutter Updated");
      expect(notes.first.description, "Advanced Flutter");
      expect(notes.first.priority, 2);
    });
   
   // 4. DELETE
    test('deleteNote should delete note', () async {
      // Arrange
      final note = NoteModel(
        "Flutter",
        "20 July",
        1,
        "Learning Flutter",
      );

      note.isSynced = 0;

      final id = await dataSource.insertNote(note);

      // Act
      final result = await dataSource.deleteNote(id);

      // Assert
      expect(result, 1);

      final notes = await dataSource.getNoteList();

      expect(notes, isEmpty);
    });

    // 5. COUNT
    test('getCount should return correct note count', () async {
      // Arrange
      final note1 = NoteModel(
        "Flutter",
        "20 July",
        1,
        "Learning Flutter",
      );

      final note2 = NoteModel(
        "Dart",
        "21 July",
        2,
        "Learning Dart",
      );

      note1.isSynced = 0;
      note2.isSynced = 0;

      await dataSource.insertNote(note1);
      await dataSource.insertNote(note2);

      // Act
      final result = await dataSource.getCount();

      // Assert
      expect(result, 2);
    });

  });
}
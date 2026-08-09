import 'package:flutter_test/flutter_test.dart';

import 'package:notekeeper_app_with_sqlite/feature/notes/data/models/notes.dart';

void main() {
  group('NoteModel Test', () {

    // --------------------------------------------------
    // CONSTRUCTOR
    // --------------------------------------------------

    test('NoteModel constructor should set values correctly', () {
      // Arrange & Act
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
        'Learning Flutter',
      );

      // Assert
      expect(note.title, 'Flutter');
      expect(note.date, '20 July');
      expect(note.priority, 1);
      expect(note.description, 'Learning Flutter');
      expect(note.id, isNull);
      expect(note.isSynced, isNull);
    });

    // --------------------------------------------------
    // CONSTRUCTOR WITH ID
    // --------------------------------------------------

    test('NoteModel.withId should set id and values correctly', () {
      // Arrange & Act
      final note = NoteModel.withId(
        10,
        'Flutter',
        '20 July',
        2,
        'Learning Flutter',
      );

      // Assert
      expect(note.id, 10);
      expect(note.title, 'Flutter');
      expect(note.date, '20 July');
      expect(note.priority, 2);
      expect(note.description, 'Learning Flutter');
      expect(note.isSynced, isNull);
    });

    // --------------------------------------------------
    // TITLE SETTER
    // --------------------------------------------------

    test('title setter should update title when valid', () {
      // Arrange
      final note = NoteModel(
        'Old Title',
        '20 July',
        1,
      );

      // Act
      note.title = 'New Title';

      // Assert
      expect(
        note.title,
        'New Title',
      );
    });

    test('title setter should not update title when length is greater than 255',
        () {
      // Arrange
      final note = NoteModel(
        'Old Title',
        '20 July',
        1,
      );

      final longTitle = 'A' * 256;

      // Act
      note.title = longTitle;

      // Assert
      expect(
        note.title,
        'Old Title',
      );
    });

    test('title setter should not update title when value is null', () {
      // Arrange
      final note = NoteModel(
        'Old Title',
        '20 July',
        1,
      );

      // Act
      note.title = null;

      // Assert
      expect(
        note.title,
        'Old Title',
      );
    });

    // --------------------------------------------------
    // DESCRIPTION SETTER
    // --------------------------------------------------

    test('description setter should update description when valid', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
        'Old Description',
      );

      // Act
      note.description = 'New Description';

      // Assert
      expect(
        note.description,
        'New Description',
      );
    });

    test(
      'description setter should not update description when length is greater than 255',
      () {
        // Arrange
        final note = NoteModel(
          'Flutter',
          '20 July',
          1,
          'Old Description',
        );

        final longDescription = 'A' * 256;

        // Act
        note.description = longDescription;

        // Assert
        expect(
          note.description,
          'Old Description',
        );
      },
    );

    test(
      'description setter should not update description when value is null',
      () {
        // Arrange
        final note = NoteModel(
          'Flutter',
          '20 July',
          1,
          'Old Description',
        );

        // Act
        note.description = null;

        // Assert
        expect(
          note.description,
          'Old Description',
        );
      },
    );

    // --------------------------------------------------
    // PRIORITY SETTER
    // --------------------------------------------------

    test('priority setter should accept priority 1', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        2,
      );

      // Act
      note.priority = 1;

      // Assert
      expect(
        note.priority,
        1,
      );
    });

    test('priority setter should accept priority 2', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
      );

      // Act
      note.priority = 2;

      // Assert
      expect(
        note.priority,
        2,
      );
    });

    test('priority setter should reject priority less than 1', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
      );

      // Act
      note.priority = 0;

      // Assert
      expect(
        note.priority,
        1,
      );
    });

    test('priority setter should reject priority greater than 2', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
      );

      // Act
      note.priority = 3;

      // Assert
      expect(
        note.priority,
        1,
      );
    });

    test('priority setter should reject null', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
      );

      // Act
      note.priority = null;

      // Assert
      expect(
        note.priority,
        1,
      );
    });

    // --------------------------------------------------
    // DATE SETTER
    // --------------------------------------------------

    test('date setter should update date', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
      );

      // Act
      note.date = '21 July';

      // Assert
      expect(
        note.date,
        '21 July',
      );
    });

    // --------------------------------------------------
    // IS SYNCED SETTER
    // --------------------------------------------------

    test('isSynced setter should update sync status', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
      );

      // Act
      note.isSynced = 1;

      // Assert
      expect(
        note.isSynced,
        1,
      );
    });

    test('isSynced setter should accept zero', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
      );

      // Act
      note.isSynced = 0;

      // Assert
      expect(
        note.isSynced,
        0,
      );
    });

    // --------------------------------------------------
    // TO MAP
    // --------------------------------------------------

    test('toMap should convert NoteModel to map', () {
      // Arrange
      final note = NoteModel.withId(
        10,
        'Flutter',
        '20 July',
        1,
        'Learning Flutter',
      );

      note.isSynced = 1;

      // Act
      final result = note.toMap();

      // Assert
      expect(
        result,
        {
          'id': 10,
          'title': 'Flutter',
          'description': 'Learning Flutter',
          'priority': 1,
          'isSynced': 1,
          'date': '20 July',
        },
      );
    });

    test('toMap should not contain id when id is null', () {
      // Arrange
      final note = NoteModel(
        'Flutter',
        '20 July',
        1,
        'Learning Flutter',
      );

      note.isSynced = 0;

      // Act
      final result = note.toMap();

      // Assert
      expect(
        result.containsKey('id'),
        false,
      );

      expect(
        result['title'],
        'Flutter',
      );

      expect(
        result['description'],
        'Learning Flutter',
      );

      expect(
        result['priority'],
        1,
      );

      expect(
        result['isSynced'],
        0,
      );

      expect(
        result['date'],
        '20 July',
      );
    });

    // --------------------------------------------------
    // FROM MAP OBJECT
    // --------------------------------------------------

    test('fromMapObject should convert map to NoteModel', () {
      // Arrange
      final map = {
        'id': 10,
        'title': 'Flutter',
        'description': 'Learning Flutter',
        'priority': 2,
        'isSynced': 1,
        'date': '20 July',
      };

      // Act
      final note = NoteModel.fromMapObject(map);

      // Assert
      expect(note.id, 10);
      expect(note.title, 'Flutter');
      expect(note.description, 'Learning Flutter');
      expect(note.priority, 2);
      expect(note.isSynced, 1);
      expect(note.date, '20 July');
    });

    // --------------------------------------------------
    // FROM MAP WITH NULL ID
    // --------------------------------------------------

    test('fromMapObject should handle null id', () {
      // Arrange
      final map = {
        'id': null,
        'title': 'Flutter',
        'description': 'Learning Flutter',
        'priority': 1,
        'isSynced': 0,
        'date': '20 July',
      };

      // Act
      final note = NoteModel.fromMapObject(map);

      // Assert
      expect(note.id, isNull);
      expect(note.title, 'Flutter');
      expect(note.description, 'Learning Flutter');
      expect(note.priority, 1);
      expect(note.isSynced, 0);
      expect(note.date, '20 July');
    });
  });
}
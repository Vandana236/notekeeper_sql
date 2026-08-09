import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:notekeeper_app_with_sqlite/core/database/database_helper.dart';

void main() {
  setUpAll(() {
    // Initialize SQLite for tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseHelper Test', () {
    test('initializeDatabase should create database and note table', () async {
      // Arrange
      final databasePath = await getDatabasesPath();

      final path = join(
        databasePath,
        DatabaseHelper.databaseName,
      );

      // Remove old database so onCreate runs
      await deleteDatabase(path);

      // Act
      final db = await DatabaseHelper.initializeDatabase();

      // Assert
      expect(db, isA<Database>());

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master "
        "WHERE type = 'table' AND name = 'note_table'",
      );

      expect(
        tables,
        isNotEmpty,
      );

      await db.close();
      await deleteDatabase(path);
    });

    test('note_table should contain required columns', () async {
      // Arrange
      final databasePath = await getDatabasesPath();

      final path = join(
        databasePath,
        DatabaseHelper.databaseName,
      );

      await deleteDatabase(path);

      // Act
      final db = await DatabaseHelper.initializeDatabase();

      final columns = await db.rawQuery(
        'PRAGMA table_info(note_table)',
      );

      final columnNames = columns
          .map((column) => column['name'])
          .toList();

      // Assert
      expect(
        columnNames,
        contains('id'),
      );

      expect(
        columnNames,
        contains('title'),
      );

      expect(
        columnNames,
        contains('description'),
      );

      expect(
        columnNames,
        contains('priority'),
      );

      expect(
        columnNames,
        contains('date'),
      );

      expect(
        columnNames,
        contains('isSynced'),
      );

      await db.close();
      await deleteDatabase(path);
    });
  });
}
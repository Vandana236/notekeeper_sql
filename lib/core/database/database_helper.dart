import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String databaseName = 'notes.db';
  static const int databaseVersion = 2;

  static Future<Database> initializeDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      databaseName,
    );

    return await openDatabase(
      path,
      version: databaseVersion,
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
    );
  }
}
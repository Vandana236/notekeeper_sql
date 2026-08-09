// import 'dart:async';
// import 'dart:io';

// import 'package:notekeeper_app_with_sqlite/feature/notes/data/models/notes.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';


// class NoteLocalDataSource {

//   static NoteLocalDataSource? _databaseHelper;
//   static Database? _database;

//   /// TABLE NAME
//   String noteTable = 'note_table';

//   /// COLUMN NAMES
//   String colId = 'id';
//   String colTitle = 'title';
//   String colDescription = 'description';
//   String colPriority = 'priority';
//   String colDate = 'date';
//   String colIsSynced = 'isSynced';

//   /// SINGLETON
//   NoteLocalDataSource._createInstance();

//   factory NoteLocalDataSource() {

//     _databaseHelper ??= NoteLocalDataSource._createInstance();

//     return _databaseHelper!;
//   }

//   /// GET DATABASE
//   Future<Database> get database async {

//     _database ??= await initializeDatabase();

//     return _database!;
//   }

//   /// INITIALIZE DATABASE
//   Future<Database> initializeDatabase() async {

//     Directory directory = await getApplicationDocumentsDirectory();

//     String path = '${directory.path}/notes.db';

//     var notesDatabase = await openDatabase(
//       path,
//       version: 2,
//       onCreate: _createDb,
//     );

//     return notesDatabase;
//   }

//   /// CREATE TABLE
//   void _createDb(Database db, int newVersion,) async {
//     await db.execute(
//       'CREATE TABLE $noteTable('
//           '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
//           '$colTitle TEXT, '
//           '$colDescription TEXT, '
//           '$colPriority INTEGER, '
//           '$colDate TEXT, '
//           '$colIsSynced INTEGER'
//           ')',
//     );
//   }

//   /// GET ALL NOTES
//   Future<List<Map<String, dynamic>>>
//   getNoteMapList() async {

//     Database db = await database;

//     var result = await db.query(
//       noteTable,
//       orderBy: '$colPriority ASC',
//     );

//     return result;
//   }

//   /// INSERT NOTE
//   Future<int> insertNote(
//       NoteModel note,
//       ) async {

//     Database db = await database;

//     var result = await db.insert(
//       noteTable,
//       note.toMap(),
//     );

//     return result;
//   }

//   /// UPDATE NOTE
//   Future<int> updateNote(
//       NoteModel note,
//       ) async {

//     Database db = await database;

//     var result = await db.update(
//       noteTable,
//       note.toMap(),
//       where: '$colId = ?',
//       whereArgs: [note.id],
//     );

//     return result;
//   }

//   /// DELETE NOTE
//   Future<int> deleteNote(
//       int id,
//       ) async {

//     Database db = await database;

//     int result = await db.rawDelete(
//       'DELETE FROM $noteTable '
//           'WHERE $colId = $id',
//     );

//     return result;
//   }

//   /// GET NOTE COUNT
//   Future<int> getCount() async {

//     Database db = await database;

//     List<Map<String, dynamic>> result =
//     await db.rawQuery(
//       'SELECT COUNT (*) from $noteTable',
//     );

//     int count = Sqflite.firstIntValue(result) ?? 0;

//     return count;
//   }

//   /// CONVERT MAP LIST TO NOTE LIST
//   Future<List<NoteModel>> getNoteList() async {

//     var noteMapList = await getNoteMapList();

//     int count = noteMapList.length;

//     List<NoteModel> noteList = [];

//     for (int i = 0; i < count; i++) {

//       noteList.add(
//         NoteModel.fromMapObject(
//           noteMapList[i],
//         ),
//       );
//     }

//     return noteList;
//   }
// }
import 'package:notekeeper_app_with_sqlite/feature/notes/data/models/notes.dart';
import 'package:sqflite/sqflite.dart';

class NoteLocalDataSource {
  final Database database;

  NoteLocalDataSource({
    required this.database,
  });

  /// TABLE NAME
  static const String noteTable = 'note_table';

  /// COLUMN NAMES
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colDescription = 'description';
  static const String colPriority = 'priority';
  static const String colDate = 'date';
  static const String colIsSynced = 'isSynced';

  /// GET ALL NOTES
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    return await database.query(
      noteTable,
      orderBy: '$colPriority ASC',
    );
  }

  /// INSERT NOTE
  Future<int> insertNote(NoteModel note) async {
    return await database.insert(
      noteTable,
      note.toMap(),
    );
  }

  /// UPDATE NOTE
  Future<int> updateNote(NoteModel note) async {
    return await database.update(
      noteTable,
      note.toMap(),
      where: '$colId = ?',
      whereArgs: [note.id],
    );
  }

  /// DELETE NOTE
  Future<int> deleteNote(int id) async {
    return await database.delete(
      noteTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  /// GET NOTE COUNT
  Future<int> getCount() async {
    final result = await database.rawQuery(
      'SELECT COUNT(*) FROM $noteTable',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// GET NOTE LIST
  Future<List<NoteModel>> getNoteList() async {
    final noteMapList = await getNoteMapList();

    return noteMapList
        .map((e) => NoteModel.fromMapObject(e))
        .toList();
  }
}
 

import 'package:notekeeper_app_with_sqlite/feature/notes/data/datasource/note_local_datasource.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/data/models/notes.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/domain/entities/note.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/domain/repositories.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl(this.localDataSource);

  @override
  Future<int> addNote(Note note) async {
    final model = NoteModel(
      note.title,
      note.date,
      note.priority,
      note.description,
    );

    model.isSynced = 0;

    return await localDataSource.insertNote(model);
  }

  @override
  Future<List<Note>> getNotes() async {
    final notes = await localDataSource.getNoteList();

    return notes.map((e) {
      return Note(
        id: e.id,
        title: e.title ?? "",
        description: e.description ?? "",
        date: e.date ?? "",
        priority: e.priority ?? 1,
      );
    }).toList();
  }

  @override
  Future<int> updateNote(Note note) async {
    final model = NoteModel.withId(
      note.id,
      note.title,
      note.date,
      note.priority,
      note.description,
    );

    model.isSynced = 0;

    return await localDataSource.updateNote(model);
  }

  @override
  Future<int> deleteNote(int id) async {
    return await localDataSource.deleteNote(id);
  }
}
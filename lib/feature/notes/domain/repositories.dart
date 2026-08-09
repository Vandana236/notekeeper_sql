 

import 'package:notekeeper_app_with_sqlite/feature/notes/domain/entities/note.dart';

abstract class NoteRepository {
  Future<int> addNote(Note note);

  Future<List<Note>> getNotes();

  Future<int> updateNote(Note note);

  Future<int> deleteNote(int id);
}
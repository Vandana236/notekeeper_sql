import 'package:notekeeper_app_with_sqlite/feature/notes/domain/entities/note.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/domain/repositories.dart';
 

class AddNoteUseCase {

  final NoteRepository repository;

  AddNoteUseCase(this.repository);

  Future<void> call(Note note) {
    return repository.addNote(note);
  }

}

class GetNotesUseCase {

  final NoteRepository repository;

  GetNotesUseCase(this.repository);

  Future<List<Note>> call() {
    return repository.getNotes();
  }

}

class DeleteNoteUseCase {

  final NoteRepository repository;

  DeleteNoteUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteNote(id);
  }

}
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:notekeeper_app_with_sqlite/feature/notes/domain/entities/note.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/domain/repositories.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/domain/usecases.dart'; 

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late MockNoteRepository mockRepository;

  setUp(() {
    mockRepository = MockNoteRepository();
  });

  group('AddNoteUseCase Test', () {
    test('should call repository.addNote', () async {
      // Arrange
      final useCase = AddNoteUseCase(mockRepository);

      final note = Note(
        title: 'Flutter',
        description: 'Learning Flutter',
        date: '20 July',
        priority: 1,
      );

      when(
        () => mockRepository.addNote(note),
      ).thenAnswer(
        (_) async => 1,
      );

      // Act
      await useCase(note);

      // Assert
      verify(
        () => mockRepository.addNote(note),
      ).called(1);
    });
  });

  group('GetNotesUseCase Test', () {
    test('should return notes from repository', () async {
      // Arrange
      final useCase = GetNotesUseCase(mockRepository);

      final notes = [
        Note(
          id: 1,
          title: 'Flutter',
          description: 'Learning Flutter',
          date: '20 July',
          priority: 1,
        ),
        Note(
          id: 2,
          title: 'Dart',
          description: 'Learning Dart',
          date: '21 July',
          priority: 2,
        ),
      ];

      when(
        () => mockRepository.getNotes(),
      ).thenAnswer(
        (_) async => notes,
      );

      // Act
      final result = await useCase();

      // Assert
      expect(result.length, 2);
      expect(result.first.title, 'Flutter');
      expect(result[1].title, 'Dart');

      verify(
        () => mockRepository.getNotes(),
      ).called(1);
    });
  });

  group('DeleteNoteUseCase Test', () {
    test('should call repository.deleteNote', () async {
      // Arrange
      final useCase = DeleteNoteUseCase(mockRepository);

      when(
        () => mockRepository.deleteNote(1),
      ).thenAnswer(
        (_) async => 1,
      );

      // Act
      await useCase(1);

      // Assert
      verify(
        () => mockRepository.deleteNote(1),
      ).called(1);
    });
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notekeeper_app_with_sqlite/feature/notes/presentation/widgets/note_tile.dart';

void main() {
  testWidgets(
    'NoteTile should display title and date',
    (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteTile(
              title: 'Flutter',
              date: '20 July',
              priority: 1,
              isSynced: 1,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.text('Flutter'),
        findsOneWidget,
      );

      expect(
        find.text('20 July'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'NoteTile should show cloud_done when note is synced',
    (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteTile(
              title: 'Flutter',
              date: '20 July',
              priority: 1,
              isSynced: 1,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.byIcon(Icons.cloud_done),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.cloud_off),
        findsNothing,
      );
    },
  );

  testWidgets(
    'NoteTile should show cloud_off when note is not synced',
    (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteTile(
              title: 'Flutter',
              date: '20 July',
              priority: 1,
              isSynced: 0,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.byIcon(Icons.cloud_off),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.cloud_done),
        findsNothing,
      );
    },
  );

  testWidgets(
    'NoteTile should call onTap when tile is tapped',
    (tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteTile(
              title: 'Flutter',
              date: '20 July',
              priority: 1,
              isSynced: 0,
              onTap: () {
                tapped = true;
              },
              onDelete: () {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(
        find.byType(ListTile),
      );

      await tester.pump();

      // Assert
      expect(
        tapped,
        true,
      );
    },
  );

  testWidgets(
    'NoteTile should call onDelete when delete button is tapped',
    (tester) async {
      // Arrange
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteTile(
              title: 'Flutter',
              date: '20 July',
              priority: 1,
              isSynced: 0,
              onTap: () {},
              onDelete: () {
                deleted = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(
        find.byIcon(Icons.delete),
      );

      await tester.pump();

      // Assert
      expect(
        deleted,
        true,
      );
    },
  );
}
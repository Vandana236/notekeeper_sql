import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notekeeper_app_with_sqlite/core/app_navigation.dart';

void main() {
  group('AppNavigator Test', () {
    testWidgets(
      'push should navigate to new page',
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AppNavigator.push(
                        context,
                        const SecondPage(),
                      );
                    },
                    child: const Text('Go'),
                  ),
                );
              },
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Go'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Second Page'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'pushReplacement should replace current page',
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      AppNavigator.pushReplacement(
                        context,
                        const SecondPage(),
                      );
                    },
                    child: const Text('Replace'),
                  ),
                );
              },
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Replace'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Second Page'),
          findsOneWidget,
        );

        expect(
          find.text('Replace'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'pop should return true',
      (tester) async {
        // Arrange
        bool? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      result = await AppNavigator.push(
                        context,
                        const PopTestPage(),
                      );
                    },
                    child: const Text('Open'),
                  ),
                );
              },
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Assert page opened
        expect(
          find.text('Pop Test Page'),
          findsOneWidget,
        );

        // Act - pop the page
        await tester.tap(find.text('Pop'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          result,
          true,
        );

        expect(
          find.text('Pop Test Page'),
          findsNothing,
        );
      },
    );
  });
}

/// Page used for push and pushReplacement tests
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Second Page'),
      ),
    );
  }
}

/// Page used for pop test
class PopTestPage extends StatelessWidget {
  const PopTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Pop Test Page'),

          ElevatedButton(
            onPressed: () {
              AppNavigator.pop(context);
            },
            child: const Text('Pop'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:notekeeper_app_with_sqlite/core/database/database_helper.dart';
import 'package:notekeeper_app_with_sqlite/feature/notes/data/datasource/note_local_datasource.dart';
import 'feature/notes/presentation/pages/notes_list_page.dart';
import 'dart:ui'; 
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /// FLUTTER ERRORS
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  /// ASYNC ERRORS
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    );
    return true;
  };
   final db = await DatabaseHelper.initializeDatabase();

  final dataSource = NoteLocalDataSource(
    database: db,
  );

  runApp(  MyApp(dataSource: dataSource,));
}

class MyApp extends StatelessWidget {
   final NoteLocalDataSource dataSource;
  const MyApp({super.key,
  required this.dataSource,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home:  NotesListPage( dataSource: dataSource,),
      // ListWidget()

    );
  }
}

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {

  List<int> counts = List.generate(100, (_) => 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter List"),
      ),
      body: ListView.builder(
        itemCount: counts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Item ${index + 1}"),
            trailing: Text(
              counts[index].toString(),
              style: const TextStyle(fontSize: 20),
            ),
            onTap: () {
              setState(() {
                counts[index]++;
              });
            },
          );
        },
      ),
    );
  }
}
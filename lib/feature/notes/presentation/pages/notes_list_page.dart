import 'package:flutter/material.dart';

import '../../../../core/services/native/native_service.dart';
import '../../../../core/utils/priority_helper.dart';
import '../../data/datasource/note_local_datasource.dart';
import '../../data/models/notes.dart';
import '../widgets/note_tile.dart';
import 'add_edit_note_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {

  /// DATABASE
  final NoteLocalDataSource databaseHelper = NoteLocalDataSource();

  /// NOTE LIST
  List<NoteModel> noteList = [];
  bool isOnline = true;
  /// NOTE COUNT
  int count = 0;
  int batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    updateListView();
    loadBatteryLevel();
  }

  /// UPDATE LIST VIEW
  void updateListView() async {

    try {

      final notes =
      await databaseHelper
          .getNoteList();

      setState(() {

        noteList = notes;

        count = notes.length;
      });

    } catch (e, stack) {

      /// CRASHLYTICS
      await FirebaseCrashlytics
          .instance
          .recordError(
        e,
        stack,
      );

      /// SNACKBAR
      PriorityHelper.showSnackBar(

        context,

        "Failed to Load Notes",
      );
    }
  }

  /// DELETE NOTE
  void deleteNote(BuildContext context, int id,) async {
    int result = await databaseHelper.deleteNote(id);
    if (result != 0) {
      PriorityHelper.showSnackBar(
        context,
        "Note Deleted Successfully",
      );
      updateListView();
    }
  }
  Future<void> loadBatteryLevel()
  async {

    final level =
    await NativeService
        .getBatteryLevel();

    setState(() {

      batteryLevel = level;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Notes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        // actions: [
        //
        //   Padding(
        //     padding: const EdgeInsets.all(12),
        //
        //     child: Center(
        //       child: Text(
        //         '$batteryLevel%',
        //         style: const TextStyle(
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],

        // you can crash your app manualy by clicking on the bug icon
        actions: [

          IconButton(

            onPressed: () {

              FirebaseCrashlytics
                  .instance
                  .crash();
            },

            icon: const Icon(
              Icons.bug_report,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: count == 0
      /// EMPTY UI
          ? const Center(
        child: Text(
          "No Notes Available",
        ),
      )

      /// NOTES LIST
          : ListView.builder(
        itemCount: count,
        itemBuilder: (context, index,) {
          return NoteTile(
            /// TITLE
            title: noteList[index].title ?? '',

            /// DATE
            date: noteList[index].date ?? '',

            /// PRIORITY
            priority: noteList[index].priority ?? 1,

            /// EDIT NOTE
            onTap: () async {

              try {

                bool? result =
                await Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        AddEditNotePage(
                          note:
                          noteList[index],
                        ),
                  ),
                );

                if (result == true) {

                  updateListView();
                }

              } catch (e, stack) {

                /// CRASHLYTICS
                await FirebaseCrashlytics
                    .instance
                    .recordError(
                  e,
                  stack,
                );

                /// SNACKBAR
                PriorityHelper.showSnackBar(

                  context,

                  "Navigation Failed",
                );
              }
            },

            /// DELETE NOTE
            onDelete: () {

              deleteNote(
                context,
                noteList[index].id!,
              );
            },
            isSynced: noteList[index].isSynced ?? 0,
          );
        },
      ),

      /// ADD NOTE
      floatingActionButton:
      FloatingActionButton(

        backgroundColor:
        Colors.deepPurple,

        onPressed: () async {

          try {

            bool? result =
            await Navigator.push(

              context,

              MaterialPageRoute(

                builder: (_) =>
                const AddEditNotePage(),
              ),
            );

            if (result == true) {

              updateListView();
            }

          } catch (e, stack) {

            /// CRASHLYTICS
            await FirebaseCrashlytics
                .instance
                .recordError(
              e,
              stack,
            );

            /// SNACKBAR
            PriorityHelper.showSnackBar(

              context,

              "Failed to Open Add Note Page",
            );
          }
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
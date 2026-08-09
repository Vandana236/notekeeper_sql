import 'package:flutter/material.dart';

import '../../../../core/services/crashlytics_service.dart';
import '../../../../core/utils/priority_helper.dart';
import '../../data/datasource/note_local_datasource.dart';
import '../../data/models/notes.dart';
import '../widgets/note_tile.dart';
import 'add_edit_note_page.dart';

class NotesListPage extends StatefulWidget {
  final NoteLocalDataSource dataSource;

  final CrashlyticsService crashlyticsService;

  const NotesListPage({
    super.key,
    required this.dataSource,
    this.crashlyticsService = const CrashlyticsService(),
  });

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {

  /// DATABASE
  late NoteLocalDataSource dataSource;

  /// CRASHLYTICS
  late CrashlyticsService crashlyticsService;

  /// NOTE LIST
  List<NoteModel> noteList = [];

  /// NOTE COUNT
  int count = 0;

  // ============================================================
  // BATTERY CODE - COMMENTED FOR NOW
  // ============================================================

  // int batteryLevel = 0;

  @override
  void initState() {
    super.initState();

    dataSource = widget.dataSource;

    crashlyticsService =
        widget.crashlyticsService;

    updateListView();

    // Battery code commented
    // loadBatteryLevel();
  }

  /// UPDATE LIST VIEW
  Future<void> updateListView() async {
    try {
      final notes =
          await dataSource.getNoteList();

      if (!mounted) return;

      setState(() {
        noteList = notes;
        count = notes.length;
      });
    } catch (e, stack) {

      await crashlyticsService.recordError(
        e,
        stack,
      );

      if (!mounted) return;

      PriorityHelper.showSnackBar(
        context,
        "Failed to Load Notes",
      );
    }
  }

  /// DELETE NOTE
  Future<void> deleteNote(
    BuildContext context,
    int id,
  ) async {
    try {
      final result =
          await dataSource.deleteNote(id);

      if (result != 0) {
        if (!mounted) return;

        PriorityHelper.showSnackBar(
          context,
          "Note Deleted Successfully",
        );

        await updateListView();
      }
    } catch (e, stack) {

      await crashlyticsService.recordError(
        e,
        stack,
      );

      if (!mounted) return;

      PriorityHelper.showSnackBar(
        context,
        "Failed to Delete Note",
      );
    }
  }

  // ============================================================
  // BATTERY CODE - COMMENTED FOR NOW
  // ============================================================

  // Future<void> loadBatteryLevel() async {
  //   try {
  //     final level =
  //         await NativeService.getBatteryLevel();

  //     if (!mounted) return;

  //     setState(() {
  //       batteryLevel = level;
  //     });
  //   } catch (e, stack) {
  //     await crashlyticsService.recordError(
  //       e,
  //       stack,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.deepPurple,

        title: const Text(
          "Notes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        // ======================================================
        // BATTERY UI - COMMENTED FOR NOW
        // ======================================================

        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(12),
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

        /// CRASHLYTICS TEST BUTTON
        actions: [
          IconButton(
            onPressed: () {
              crashlyticsService.crash();
            },
            icon: const Icon(
              Icons.bug_report,
              color: Colors.white,
            ),
          ),
        ],
      ),

      /// BODY
      body: count == 0
          ? const Center(
              child: Text(
                "No Notes Available",
              ),
            )
          : ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {

                final note =
                    noteList[index];

                return NoteTile(
                  /// TITLE
                  title: note.title ?? '',

                  /// DATE
                  date: note.date ?? '',

                  /// PRIORITY
                  priority:
                      note.priority ?? 1,

                  /// SYNC STATUS
                  isSynced:
                      note.isSynced ?? 0,

                  /// EDIT NOTE
                  onTap: () async {
                    try {

                      final result =
                          await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddEditNotePage(
                            note: note,
                            dataSource:
                                dataSource,
                          ),
                        ),
                      );

                      if (result == true) {
                        await updateListView();
                      }

                    } catch (e, stack) {

                      await crashlyticsService
                          .recordError(
                        e,
                        stack,
                      );

                      if (!mounted) return;

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
                      note.id!,
                    );
                  },
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

            final result =
                await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AddEditNotePage(
                  dataSource:
                      dataSource,
                ),
              ),
            );

            if (result == true) {
              await updateListView();
            }

          } catch (e, stack) {

            await crashlyticsService
                .recordError(
              e,
              stack,
            );

            if (!mounted) return;

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
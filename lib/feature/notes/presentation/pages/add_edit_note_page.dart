import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper_app_with_sqlite/core/app_navigation.dart';

import '../../../../core/utils/priority_helper.dart';
import '../../data/datasource/note_local_datasource.dart';
import '../../data/models/notes.dart';

import '../widgets/note_button.dart';
import '../widgets/note_dropdown.dart';
import '../widgets/note_textfield.dart';


class AddEditNotePage extends StatefulWidget {

  final NoteModel? note;
  final NoteLocalDataSource dataSource;

  const AddEditNotePage({
    super.key,
    this.note,
    required this.dataSource,
  });

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {

  /// CONTROLLERS
  late TextEditingController titleController;

  late TextEditingController descriptionController;

  /// PRIORITY
  late String priority;

  @override
  void initState() {
    super.initState();
    /// TITLE
    titleController =
        TextEditingController(
          text: widget.note?.title ?? "",
        );
    /// DESCRIPTION
    descriptionController =
        TextEditingController(
          text:
          widget.note?.description ?? "",
        );

    /// PRIORITY
    priority =
        PriorityHelper
            .getPriorityAsString(
          widget.note?.priority ?? 2,
        );
  }

  @override
  void dispose() {

    titleController.dispose();

    descriptionController.dispose();

    super.dispose();
  }

  /// SAVE NOTE
  void saveNote() async {

    String title = titleController.text;

    String description =
        descriptionController.text;

    /// VALIDATION
    if (title.isEmpty) {

      PriorityHelper.showSnackBar(
        context,
        "Please Enter Title",
      );

      return;
    }

    try {

      /// STRING TO INT
      int priorityValue =
      PriorityHelper
          .updatePriorityAsInt(
        priority,
      );

      /// NOTE OBJECT
      NoteModel note = NoteModel(

        title,

        DateFormat(
          'dd MMM yyyy, hh:mm:ss a',
        ).format(
          DateTime.now(),
        ),

        priorityValue,

        description,
      );
      note.isSynced = 0;
      final helper = widget.dataSource;

      /// UPDATE NOTE
      if (widget.note != null) {

        note = NoteModel.withId(
          widget.note!.id,
          title,
          DateFormat(
            'dd MMM yyyy, hh:mm:ss a',
          ).format(
            DateTime.now(),
          ),
          priorityValue,
          description,
        );

        note.isSynced = 0;

        await helper.updateNote(note);

        PriorityHelper.showSnackBar(
          context,
          "Note Updated Successfully",
        );
      }

      /// INSERT NOTE
      else {
        await helper.insertNote(note);

        PriorityHelper.showSnackBar(

          context,

          "Note Saved Successfully",
        );
      }

      AppNavigator.pop(context);

    } catch (e, stack) {

      /// CRASHLYTICS ERROR
      await FirebaseCrashlytics
          .instance
          .recordError(
        e,
        stack,
      );

      /// SNACKBAR
      PriorityHelper.showSnackBar(

        context,

        "Something went wrong",
      );
    }
  }

  /// DELETE NOTE
  void deleteNote() async {

    if (widget.note == null) {
      return;
    }

    try {

     await widget.dataSource.deleteNote(
  widget.note!.id!,
);

      PriorityHelper.showSnackBar(

        context,

        "Note Deleted Successfully",
      );

      AppNavigator.pop(context);

    } catch (e, stack) {

      /// CRASHLYTICS
      await FirebaseCrashlytics
          .instance
          .recordError(
        e,
        stack,
      );

      /// ERROR SNACKBAR
      PriorityHelper.showSnackBar(

        context,

        "Failed to Delete Note",
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final bool isEdit =
        widget.note != null;

    return PopScope(

      canPop: true,

      onPopInvoked: (didPop) {

        if (didPop) {
          return;
        }

        AppNavigator.pop(context);
      },

      child: Scaffold(

        appBar: AppBar(

          backgroundColor:
          Colors.deepPurple,

          title: Text(

            isEdit
                ? "Edit Note"
                : "Add Note",

            style: const TextStyle(
              color: Colors.white,
            ),
          ),

          leading: IconButton(

            onPressed: () {
              AppNavigator.pop(context);
            },

            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),

        body: Padding(

          padding:
          const EdgeInsets.all(16),

          child: Column(

            children: [

              /// DROPDOWN
              NoteDropdown(

                selectedPriority:
                priority,

                onChanged: (value) {

                  setState(() {

                    priority = value!;
                  });
                },
              ),

              const SizedBox(
                height: 20,
              ),

              /// TITLE
              NoteTextField(

                hintText: "Title",

                controller:
                titleController,
              ),

              const SizedBox(
                height: 20,
              ),

              /// DESCRIPTION
              NoteTextField(

                hintText: "Description",

                maxLines: 4,

                controller:
                descriptionController,
              ),

              const SizedBox(
                height: 30,
              ),

              Row(

                children: [

                  /// SAVE BUTTON
                  Expanded(

                    child: NoteButton(

                      text: "Save",

                      backgroundColor:
                      Colors.deepPurple,

                      onPressed: saveNote,
                    ),
                  ),

                  /// DELETE BUTTON
                  if (isEdit) ...[

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(

                      child: NoteButton(

                        text: "Delete",

                        backgroundColor:
                        Colors.red,

                        onPressed:
                        deleteNote,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
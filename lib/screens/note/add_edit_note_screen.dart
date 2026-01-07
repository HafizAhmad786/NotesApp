import 'package:flutter/material.dart';
import 'package:notes_app/components/custom_textfield.dart';
import 'package:notes_app/data/models/note.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/screens/note/notes_screen.dart';
import 'package:provider/provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? noteData;

  const AddEditNoteScreen({super.key, this.noteData});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late NoteProvider noteProvider;

  @override
  void initState() {
    super.initState();
    noteProvider = Provider.of<NoteProvider>(context, listen: false);
    if (widget.noteData != null) {
      noteProvider.initializeValues(widget.noteData!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.noteData != null ? "Update Note" : "Create Note",
          style: TextStyle(fontWeight: .bold, fontStyle: .italic),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 10,
            children: [
              CustomTextField(title: "Title", controller: noteProvider.title),
              CustomTextField(
                controller: noteProvider.content,
                maxLines: 15,
                title: "Content",
              ),
              Consumer<NoteProvider>(
                builder: (_, controller, child) {
                  return Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (widget.noteData != null) {
                                await noteProvider.updateNote(widget.noteData!);
                              } else {
                                await noteProvider.createNote();
                              }

                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotesScreen(),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            widget.noteData != null
                                ? "Update Note"
                                : "Create Note",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      if (widget.noteData != null)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await noteProvider.deleteNote(widget.noteData!);
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotesScreen(),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Delete Note",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

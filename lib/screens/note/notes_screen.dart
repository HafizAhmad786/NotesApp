import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/components/custom_column.dart';
import 'package:notes_app/components/custom_textfield.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/screens/note/add_edit_note_screen.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late NoteProvider noteProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      noteProvider = Provider.of<NoteProvider>(context, listen: false);
      noteProvider.getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text("Notes", style: TextStyle(fontWeight: .bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => noteProvider.getAllNotes(),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => noteProvider.logout(context),
          )
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (_, controller, child) {
          return Column(
            spacing: 10,
            children: [
              Padding(
                  padding: const .symmetric(horizontal: 20),
                  child: CustomTextField(controller: controller.search,
                  onChange: (value) => controller.filterContent(value!),
                  )),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.notes.length,
                  itemBuilder: (context, index) {
                    if (controller.isLoading == false && controller.notes.isEmpty) {
                      return Center(
                        child: Text("No notes found", style: TextStyle(fontSize: 26)),
                      );
                    }
                    var currentNote = controller.notes[index];
                    return InkWell(
                      borderRadius: .circular(20),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddEditNoteScreen(noteData: currentNote),
                        ),
                      ),
                      child: Column(
                        spacing: 14,
                        children: [
                          Container(
                            padding: .all(10),
                            margin: .symmetric(horizontal: 20),
                            alignment: .center,
                            width: MediaQuery.sizeOf(context).width,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: .circular(10),
                              color: Colors.grey.withValues(alpha: 0.1),
                            ),
                            child: Text(
                              currentNote.content ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            ),
                          ),
                          CustomColumn(
                            title: "Title",
                            subTitle: currentNote.title ?? "",
                          ),
                          Row(
                            spacing: 10,
                            mainAxisAlignment: .spaceAround,
                            children: [
                              CustomColumn(
                                title: "Created At",
                                subTitle: DateFormat(
                                  'h:m:a d-M-yyyy',
                                ).format(currentNote.createdAt!),
                              ),
                              CustomColumn(
                                title: "Updated At",
                                subTitle: DateFormat(
                                  'h:m:a d-M-yyyy',
                                ).format(currentNote.updatedAt!),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, index) =>
                      const Divider(color: Colors.grey, thickness: 2),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditNoteScreen()),
          );
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.edit, color: Colors.red),
      ),
    );
  }
}

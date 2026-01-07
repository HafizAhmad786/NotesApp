import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/data/models/note.dart';
import 'package:notes_app/data/services/note_service.dart';
import 'package:notes_app/screens/auth/login_screen.dart';
import 'package:notes_app/screens/note/notes_screen.dart';
import 'package:notes_app/utils/loader.dart';

import '../data/services/storage_service.dart';

class NoteProvider extends ChangeNotifier {
  var title = TextEditingController();
  var content = TextEditingController();
  var search = TextEditingController();
  var noteServices = NoteService();
  StorageService storageService = StorageService();

  List<Note> _notes = [];
  List<Note> originalNotes = [];

  List<Note> get notes => _notes;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool isEditable(Note note) {
    if (note.id != null && note.id!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void initializeValues(Note? noteData) {
    if (noteData != null) {
      title.text = noteData.title ?? "";
      content.text = noteData.content ?? "";
    } else {
      title.clear();
      content.clear();
    }
  }

  void filterContent(String value) {
    String searchValue = value.toLowerCase().trim();

    if (searchValue.isEmpty) {
      _notes = originalNotes;
    } else {
      // Filter notes by title OR content
      _notes = originalNotes.where((note) {
        final title = note.title?.toLowerCase() ?? '';
        final content = note.content?.toLowerCase() ?? '';

        return title.contains(searchValue) ||
            content.contains(searchValue);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> createNote() async {
    showLoader();
    await noteServices.createNote(
      Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.text,
        content: content.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: await storageService.getUserId(),
      ),
    );

    hideLoader();
  }

  Future<void> updateNote(Note currentNote) async {
    showLoader();

    await noteServices.updateNote(
      Note(
        id: currentNote.id,
        title: title.text,
        content: content.text,
        createdAt: currentNote.createdAt,
        updatedAt: DateTime.now(),
        userId: await storageService.getUserId(),
      ),
    );

    hideLoader();
  }

  Future<void> deleteNote(Note noteData) async {
    showLoader();
    await noteServices.deleteNote(noteData);
    hideLoader();
  }

  Future<void> getAllNotes() async {
    showLoader();
    _isLoading = true;
    notifyListeners();

    _notes = await noteServices.getAllNotes(await storageService.getUserId());
    originalNotes = List.from(_notes);
    notifyListeners();
    _isLoading = false;
    notifyListeners();
    hideLoader();
  }

  Future<void> logout(BuildContext context) async {
    var auth = FirebaseAuth.instance;
    showLoader();
    await auth.signOut();
    await storageService.removeUserId();
    hideLoader();
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => LoginScreen(),
    ));
  }
}

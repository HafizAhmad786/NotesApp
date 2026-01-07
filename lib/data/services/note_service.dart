import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/data/models/note.dart';

class NoteService {
  var firebaseStorage = FirebaseFirestore.instance.collection("notes");

  Future<List<Note>> getAllNotes(String userId) async {
    try {
      var allNotes = await firebaseStorage
          .doc(userId)
          .collection("userNotes")
          .get();
      if (allNotes.docs.isNotEmpty) {
        return allNotes.docs
            .map((doc) => Note.fromFireStore(doc.data()))
            .toList();
      }
      return [];
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> createNote(Note noteData) async {
    if (noteData.toFireStore() == {}) return;
    try {
      await firebaseStorage
          .doc(noteData.userId)
          .collection("userNotes")
          .doc(noteData.id)
          .set(noteData.toFireStore());
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateNote(Note noteData) async {
    if (noteData.id == null || noteData.id!.isEmpty) return;
    try {
      await firebaseStorage
          .doc(noteData.userId)
          .collection("userNotes")
          .doc(noteData.id)
          .update(noteData.toFireStore());
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteNote(Note noteData) async {
    if (noteData.toFireStore() == {}) return;
    try {
      await firebaseStorage
          .doc(noteData.userId)
          .collection("userNotes")
          .doc(noteData.id)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  Future<Note> getCurrentNote(String noteId) async {
    try {
      return await firebaseStorage
              .where((note) => "note_id", isEqualTo: noteId)
              .get()
          as Note;
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}

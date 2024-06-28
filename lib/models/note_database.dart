import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;
// Initialize db
  static Future<void> intialize() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

// list of notes
  final List<Note> currentNotes = [];
// Create note in db and save
  Future<void> addNote(String textFromUser) async {
    // create a new object
    final newNote = Note()..text = textFromUser;
    // save to db
    await isar.writeTxn(() => isar.notes.put(newNote));
    // Re read from db
    fetchNotes();
  }

// Read note from db
  Future<void> fetchNotes() async {
    List<Note> fetchNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);
    notifyListeners();
  }

// Update note and save in db
  Future<void> updateNotes(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

// Delete note from db
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    fetchNotes();
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  final Box<Note> noteBox = Hive.box<Note>('notes');

  List<Note> get notes {
    final allNotes = noteBox.values.toList();
    allNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allNotes;
  }

  void addNote(Note note) {
    noteBox.add(note);
    notifyListeners();
  }

  void updateNote(int index, Note note) {
    noteBox.putAt(index, note);
    notifyListeners();
  }

  void deleteNote(int index) {
    noteBox.deleteAt(index);
    notifyListeners();
  }
}

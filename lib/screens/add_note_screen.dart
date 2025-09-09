import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final int? index;

  const AddNoteScreen({super.key, this.note, this.index});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String? _titleError;
  String? _descError;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descController.text = widget.note!.description;
    }
  }

  void _saveNote() {
    setState(() {
      _titleError = _titleController.text.isEmpty
          ? "Title cannot be empty"
          : null;
      _descError = _descController.text.isEmpty
          ? "Description cannot be empty"
          : null;
    });

    if (_titleController.text.isEmpty || _descController.text.isEmpty) return;

    final newNote = Note(
      title: _titleController.text,
      description: _descController.text,
      createdAt: DateTime.now(),
    );

    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    if (widget.note == null) {
      noteProvider.addNote(newNote);
    } else {
      noteProvider.updateNote(widget.index!, newNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Add Note" : "Edit Note"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                errorText: _titleError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Description",
                errorText: _descError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:bionic/pages/question_two/data/isar_service.dart';
import 'package:bionic/pages/question_two/data/note_entities.dart';

class AddNote extends StatefulWidget {
  final IsarService service;
  const AddNote({super.key, required this.service});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter your note',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  widget.service.saveCourse(NoteEntities()..title = _textController.text);
                  _textController.clear();
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note is not allowed to be empty'),
                    ),
                  );
                }
              },
              child: const Text('Add Note'),
            ),
          ],
        ),
      ),
    );
  }
}

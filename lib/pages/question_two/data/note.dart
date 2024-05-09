import 'package:bionic/pages/question_two/data/isar_service.dart';
import 'package:bionic/pages/question_two/data/note_entities.dart';
import 'package:bionic/pages/question_two/data/add_note.dart';
import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  Note({super.key});
  final service = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(
                service: service,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: const Text('Storage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<List<NoteEntities>>(
              stream: service.listenToNotes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final note = snapshot.data![index];
                        return ListTile(
                          title: Text(note.title),
                          trailing: TextButton(
                            onPressed: () {
                              service.deleteNote(note);
                            },
                            child: const Icon(Icons.delete),
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

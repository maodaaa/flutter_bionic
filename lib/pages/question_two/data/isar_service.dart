import 'package:bionic/app_initializer.dart';
import 'package:bionic/pages/question_two/data/note_entities.dart';
import 'package:isar/isar.dart';

class IsarService {
  Future<void> saveCourse(NoteEntities noteEntities) async {
    isar.writeTxnSync<int>(() => isar.noteEntities.putSync(noteEntities));
  }

  Future<List<NoteEntities>> getAllCourses() async {
    return await isar.noteEntities.where().findAll();
  }

  Stream<List<NoteEntities>> listenToNotes() async* {
    yield* isar.noteEntities.where().watch(fireImmediately: true);
  }

  Future<void> cleanDb() async {
    await isar.writeTxn(() => isar.clear());
  }

  Future<void> deleteNote(NoteEntities note) async {
    await isar.writeTxn(() => isar.noteEntities.delete(note.id));
  }
}

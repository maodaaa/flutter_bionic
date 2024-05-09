import 'package:isar/isar.dart';

part 'note_entities.g.dart';

@Collection()
class NoteEntities {
  Id id = Isar.autoIncrement;
  late String title;
}

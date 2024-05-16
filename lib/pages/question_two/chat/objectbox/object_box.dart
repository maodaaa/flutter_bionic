import 'package:bionic/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    Store store = await openStore(directory: p.join(docsDir.path, "chat_history"));
    return ObjectBox._create(store);
  }
}

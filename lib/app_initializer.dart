import 'package:bionic/constants/env.dart';
import 'package:bionic/pages/question_two/data/note_entities.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late Isar isar;

class AppInitializer {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initializeSupabase();
    await _setupIsar();
  }

  static Future<void> _initializeSupabase() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.anonKey,
    );
  }

  static Future<void> _setupIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      isar = await Isar.open(
        [NoteEntitiesSchema],
        directory: dir.path,
        name: 'bionic',
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<String>> _fetchImageUrlsFuture;

  @override
  void initState() {
    super.initState();
    _fetchImageUrlsFuture = fetchImageUrls();
  }

  Future<List<String>> fetchImageUrls() async {
    final List<FileObject> objects = await supabase.storage.from('images').list();
    if (objects.isEmpty) {
      return [];
    }
    return objects.map((file) => supabase.storage.from('images').getPublicUrl(file.name)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () async {
          if (context.mounted) {
            Navigator.of(context).pushNamed('/imagePicker');
            setState(() {
              _fetchImageUrlsFuture = fetchImageUrls();
            });
          }
        },
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchImageUrlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No images found.'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.network(
                    snapshot.data![index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

import 'package:bionic/utils/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<String>> _fetchVideosUrlsFuture;

  @override
  void initState() {
    super.initState();
    _fetchVideosUrlsFuture = fetchVideosUrls();
  }

  Future<List<String>> fetchVideosUrls() async {
    final List<FileObject> objects = await supabase.storage.from('videos').list();
    if (objects.isEmpty) {
      return [];
    }
    return objects.map((file) => supabase.storage.from('videos').getPublicUrl(file.name)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () async {
          if (context.mounted) {
            Navigator.of(context).pushNamed('/videoPicker');
            setState(() {
              _fetchVideosUrlsFuture = fetchVideosUrls();
            });
          }
        },
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchVideosUrlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Videoss found.'));
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
                  child: VideoPlayerWidget(videoUrl: snapshot.data![index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        UrlUtils.removeAfterLastExtension(widget.videoUrl),
      ),
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

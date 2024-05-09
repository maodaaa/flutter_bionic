import 'package:bionic/pages/question_two/media/image_screen.dart';
import 'package:bionic/pages/question_two/media/video_screen.dart';
import 'package:flutter/material.dart';

class Media extends StatelessWidget {
  const Media({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.image)),
              Tab(icon: Icon(Icons.videocam)),
            ],
          ),
          title: const Text('Media'),
        ),
        body: const TabBarView(
          children: [
            ImageScreen(),
            VideoScreen(),
          ],
        ),
      ),
    );
  }
}

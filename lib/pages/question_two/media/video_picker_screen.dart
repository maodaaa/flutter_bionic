import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:video_player/video_player.dart';

class VideoPickerScreen extends StatefulWidget {
  const VideoPickerScreen({super.key});

  @override
  VideoPickerScreenState createState() => VideoPickerScreenState();
}

class VideoPickerScreenState extends State<VideoPickerScreen> {
  File? _video;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('');
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future pickVideoFromGallery() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        _videoPlayerController = VideoPlayerController.file(_video!)
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController.play();
          });
      } else {
        debugPrint('No video selected.');
      }
    });
  }

  Future pickVideoFromCamera() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        _videoPlayerController = VideoPlayerController.file(_video!)
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController.play();
          });
      } else {
        debugPrint('No video selected.');
      }
    });
  }

  Future<void> _upload() async {
    if (_video == null) {
      return;
    }
    setState(() => _isLoading = true);

    final supabase = Supabase.instance.client;

    try {
      final fileName = _video!.path.split('/').last;

      await supabase.storage.from('videos').upload(fileName, _video!);

      if (mounted) {
        Navigator.pop(context);
      }
    } on StorageException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unexpected error occurred'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _video == null
                  ? const Text('No video selected.')
                  : SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickVideoFromGallery,
                child: const Text('Pick Video from Gallery'),
              ),
              ElevatedButton(
                onPressed: pickVideoFromCamera,
                child: const Text('Record a Video'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _upload,
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Upload to Supabase'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

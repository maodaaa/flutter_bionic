import 'package:bionic/app_initializer.dart';
import 'package:bionic/common/snackbar_global.dart';
import 'package:bionic/constants/app_colors.dart';
import 'package:bionic/pages/question_one/calendar.dart';
import 'package:bionic/pages/question_two/chat/screens/chat_screen.dart';
import 'package:bionic/pages/question_two/contact/contact_screen.dart';
import 'package:bionic/pages/question_two/data/note.dart';
import 'package:bionic/pages/question_two/login/login_screen.dart';
import 'package:bionic/pages/question_two/media/image_picker_screen.dart';
import 'package:bionic/pages/question_two/media/image_screen.dart';
import 'package:bionic/pages/question_two/media/media.dart';
import 'package:bionic/pages/question_two/media/video_picker_screen.dart';
import 'package:bionic/pages/question_two/media/video_screen.dart';
import 'package:bionic/pages/tabs_screen/first_menu.dart';
import 'package:bionic/pages/question_one/notes.dart';
import 'package:bionic/pages/tabs_screen/second_menu.dart';
import 'package:bionic/pages/question_one/sign_up.dart';
import 'package:bionic/pages/question_one/video.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  await AppInitializer.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: SnackbarGlobal.key,
      title: 'Flutter Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.deepPurpleColor),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/signUp': (context) => const SignUp(),
        '/calendar': (context) => const Calendar(),
        '/notes': (context) => const Notes(),
        '/video': (context) => const Video(),
        '/contact': (context) => const ContactScreen(),
        '/login': (context) => const LoginScreen(),
        '/note': (context) => Note(),
        '/media': (context) => const Media(),
        '/image': (context) => const ImageScreen(),
        '/videos': (context) => const VideoScreen(),
        '/imagePicker': (context) => const ImagePickerScreen(),
        '/videoPicker': (context) => const VideoPickerScreen(),
        '/chat': (context) => const ChatScreen(),
      },
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.one_k)),
                Tab(icon: Icon(Icons.two_k)),
              ],
            ),
            title: const Text('Flutter Test PT. Bionic'),
          ),
          body: const TabBarView(
            children: [
              FirstMenu(),
              SecondMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

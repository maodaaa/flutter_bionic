import 'package:bionic/common/menu_button.dart';
import 'package:flutter/material.dart';

class SecondMenu extends StatelessWidget {
  const SecondMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MenuButton(
              icon: Icons.login,
              label: 'Google Sign',
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
            MenuButton(
              icon: Icons.contact_phone,
              label: 'Contact',
              onPressed: () {
                Navigator.of(context).pushNamed('/contact');
              },
            ),
            MenuButton(
              icon: Icons.video_file,
              label: 'Media',
              onPressed: () {
                Navigator.of(context).pushNamed('/media');
              },
            ),
            MenuButton(
              icon: Icons.data_array,
              label: 'Data',
              onPressed: () {
                Navigator.of(context).pushNamed('/note');
              },
            ),
            MenuButton(
              icon: Icons.chat,
              label: 'Chat',
              onPressed: () {
                Navigator.of(context).pushNamed('/chat');
              },
            ),
          ],
        ),
      ),
    );
  }
}

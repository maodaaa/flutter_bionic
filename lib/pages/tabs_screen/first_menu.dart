import 'package:bionic/common/menu_button.dart';
import 'package:flutter/material.dart';

class FirstMenu extends StatelessWidget {
  const FirstMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MenuButton(
              icon: Icons.app_registration_rounded,
              label: 'Sign Up',
              onPressed: () {
                Navigator.of(context).pushNamed('/signUp');
              },
            ),
            MenuButton(
              icon: Icons.calendar_month_rounded,
              label: 'Calendar',
              onPressed: () {
                Navigator.of(context).pushNamed('/calendar');
              },
            ),
            MenuButton(
              icon: Icons.notes_rounded,
              label: 'Notes',
              onPressed: () {
                Navigator.of(context).pushNamed('/notes');
              },
            ),
            MenuButton(
              icon: Icons.videocam,
              label: 'Video',
              onPressed: () {
                Navigator.of(context).pushNamed('/video');
              },
            ),
          ],
        ),
      ),
    );
  }
}

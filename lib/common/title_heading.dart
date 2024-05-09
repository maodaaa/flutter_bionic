import 'package:flutter/material.dart';

class TitleHeading extends StatelessWidget {
  final String title;

  const TitleHeading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

import 'package:bionic/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final String btnTitle;

  final VoidCallback? onPress;

  const ButtonPrimary({
    super.key,
    required this.btnTitle,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepPurpleColor,
        fixedSize: const Size(160, 40),
      ),
      onPressed: onPress,
      child: Text(
        btnTitle,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}

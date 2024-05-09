import 'package:bionic/pages/question_two/contact/app_contact.dart';
import 'package:bionic/utils/get_color_gradient.dart';
import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar(this.contact, this.size, {super.key});
  final AppContact contact;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: getColorGradient(contact.color)),
      child: (contact.info.avatar != null && contact.info.avatar!.isNotEmpty)
          ? CircleAvatar(
              backgroundImage: MemoryImage(contact.info.avatar!),
            )
          : CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Text(
                contact.info.initials(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bionic/pages/question_two/contact/contact_detail.dart';
import 'package:flutter/material.dart';

import 'package:bionic/common/contact_avatar.dart';
import 'package:bionic/pages/question_two/contact/app_contact.dart';

class ContactsList extends StatelessWidget {
  final List<AppContact> contacts;
  final Function() reloadContacts;

  const ContactsList({
    super.key,
    required this.contacts,
    required this.reloadContacts,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          AppContact contact = contacts[index];

          return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ContactDetails(
                          contact: contact,
                          onContactDelete: (AppContact contact) {
                            reloadContacts();
                            Navigator.of(context).pop();
                          },
                          onContactUpdate: (AppContact contact) {
                            reloadContacts();
                          },
                        )));
              },
              title: Text(contact.info.displayName!),
              subtitle: Text(contact.info.phones?.isNotEmpty == true ? contact.info.phones!.first.value ?? '' : ''),
              leading: ContactAvatar(contact, 36));
        },
      ),
    );
  }
}

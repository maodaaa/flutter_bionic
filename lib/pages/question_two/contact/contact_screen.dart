import 'package:bionic/constants/app_constants.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:bionic/common/contact_list.dart';
import 'package:bionic/pages/question_two/contact/app_contact.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({
    super.key,
  });

  @override
  ContactScreenState createState() => ContactScreenState();
}

class ContactScreenState extends State<ContactScreen> {
  List<AppContact> contacts = [];
  Map<String, Color> contactsColorMap = {};
  bool contactsLoaded = false;

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
    }
  }

  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<AppContact> allContacts = (await ContactsService.getContacts()).map((contact) {
      Color baseColor = colors[colorIndex];
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
      return AppContact(info: contact, color: baseColor);
    }).toList();

    await Future.delayed(const Duration(microseconds: 300));
    setState(() {
      contacts = allContacts;
      contactsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.contacts),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await ContactsService.openContactForm();
              if (contacts.isNotEmpty) {
                getAllContacts();
              }
            } on FormOperationException catch (e) {
              switch (e.errorCode) {
                case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                case null:
              }
            }
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (contactsLoaded && contacts.isNotEmpty)
                ContactsList(
                  reloadContacts: getAllContacts,
                  contacts: contacts,
                )
              else if (contactsLoaded && contacts.isEmpty)
                const Center(
                  child: Text(
                    AppConstants.noContacts,
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ));
  }
}

import 'package:bionic/common/contact_avatar.dart';
import 'package:bionic/constants/app_constants.dart';
import 'package:bionic/pages/question_two/contact/app_contact.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatefulWidget {
  final AppContact contact;
  final Function(AppContact) onContactUpdate;
  final Function(AppContact) onContactDelete;

  const ContactDetails({
    super.key,
    required this.contact,
    required this.onContactUpdate,
    required this.onContactDelete,
  });
  @override
  ContactDetailsState createState() => ContactDetailsState();
}

class ContactDetailsState extends State<ContactDetails> {
  @override
  Widget build(BuildContext context) {
    List<String> actions = <String>[AppConstants.edit, AppConstants.delete];

    onAction(String action) async {
      switch (action) {
        case AppConstants.edit:
          try {
            Contact updatedContact = await ContactsService.openExistingContact(widget.contact.info);
            setState(() {
              widget.contact.info = updatedContact;
            });
            widget.onContactUpdate(widget.contact);
          } on FormOperationException catch (e) {
            switch (e.errorCode) {
              case FormOperationErrorCode.FORM_OPERATION_CANCELED:
              case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
              case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
              case null:
            }
          }
          break;
        case AppConstants.delete:
          _dialogBuilder(context);
          break;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 180,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Center(child: ContactAvatar(widget.contact, 100)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PopupMenuButton(
                        onSelected: onAction,
                        itemBuilder: (BuildContext context) {
                          return actions.map((String action) {
                            return PopupMenuItem(
                              value: action,
                              child: Text(action),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
                ListTile(
                  title: const Text(AppConstants.name),
                  trailing: Text(widget.contact.info.givenName ?? ""),
                ),
                ListTile(
                  title: const Text(AppConstants.familyName),
                  trailing: Text(widget.contact.info.familyName ?? ""),
                ),
                Column(
                  children: <Widget>[
                    const ListTile(title: Text(AppConstants.phone)),
                    Column(
                      children: widget.contact.info.phones!
                          .map(
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ListTile(
                                title: Text(i.label ?? ""),
                                trailing: Text(i.value ?? ""),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppConstants.deleteTitle),
          content: const Text(
            AppConstants.deleteDesc,
          ),
          actions: [
            TextButton(
              child: const Text(AppConstants.cancel),
              onPressed: () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text(AppConstants.delete),
              onPressed: () async {
                await ContactsService.deleteContact(widget.contact.info);
                widget.onContactDelete(widget.contact);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

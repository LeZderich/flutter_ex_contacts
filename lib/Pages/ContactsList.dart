import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';
import '../Services/ContactsService.dart';
import 'ContactDetails.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {

  @override
  void initState() {
    super.initState();
    // Get contacts when the widget is initialized
    Provider.of<ContactsService>(context, listen: false).getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      // Use a Consumer widget to listen for changes in the contacts list and rebuild the UI
      body: Consumer<ContactsService>(
        builder: (context, contactService, child) {
          if (contactService.cachedContacts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: contactService.cachedContacts.length,
              itemBuilder: (context, index) {
                Contact contact = contactService.cachedContacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: contact.photoOrThumbnail != null ? MemoryImage(contact.photoOrThumbnail!) : null,
                    child: contact.photoOrThumbnail == null ? Text(contact.displayName[0]) : null,
                  ),
                  title: Text(contact.displayName),
                  onTap: () {
                    contactService.getContactById(contact.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactDetails(contactService.currentContact!),
                      )
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
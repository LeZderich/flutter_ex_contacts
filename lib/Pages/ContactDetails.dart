import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:provider/provider.dart';
import '../Services/ContactsService.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;
  const ContactDetails(this.contact, {super.key});
  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
      ),
      body: Consumer<ContactsService>(
        builder: (context, contactService, child) {
          Contact? contact = contactService.currentContact;
          if (contact == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            String displayName = contact.displayName;
            List<Phone> phones = contact.phones;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: contact.photo != null ? MemoryImage(contact.photo!) : null,
                    ),
                    Positioned(
                        bottom: -2,
                        right: -2,
                        child: InkWell(
                          onTap: () async {
                            await contactService.editContact(contact);
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                    ),
                  ]
                ),
                const SizedBox(height: 50),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                for (Phone phone in phones)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(phone.number, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
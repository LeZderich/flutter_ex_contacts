import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsService extends ChangeNotifier {

  // Contacts cached in memory to avoid multiple requests
  List<Contact> _cachedContacts = [];
  List<Contact> get cachedContacts => _cachedContacts;

  Contact? _currentContact;
  Contact? get currentContact => _currentContact;

  Future<void> getContacts() async {
    await requestContactsPermission();
    await requestStoragePermission();

    if (_cachedContacts.isEmpty) {
      _cachedContacts = await FlutterContacts.getContacts(withPhoto: true);
      notifyListeners();
    }
  }
  // Future methods are used to fetch data asynchronously because the data is fetched from the device's storage and it may take some time to fetch the data.

  Future<void> getContactById(String id) async {
    _currentContact = _cachedContacts.firstWhere((contact) => contact.id == id);
    notifyListeners();
  }

  Future<void> refreshContacts() async {
    _cachedContacts = await FlutterContacts.getContacts(withPhoto: true);
    getContactById(_currentContact!.id);
    notifyListeners();
  }

  static Future requestContactsPermission() async {
    bool result = await checkContactsPermission();
    if (!result) {
      await Permission.contacts.request();
    }
  }

  static Future requestStoragePermission() async {
    bool result = await checkStoragePermission();
    if (!result) {
      await Permission.storage.request();
    }
  }

  static Future<bool> checkContactsPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (!status.isGranted) {
      return false;
    }
    return true;
  }

  static Future<bool> checkStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      return false;
    }
    return true;
  }

  // When a contact is edited, an event is fired to notify the UI to refresh the contact list.
  Future<void> editContact(Contact contact) async {
    await FlutterContacts.openExternalEdit(contact.id);
    await refreshContacts();
    notifyListeners();
  }
}

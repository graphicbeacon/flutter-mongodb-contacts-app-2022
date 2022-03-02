import 'package:contacts_app_client/contacts_app_client.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ContactsRestScreen extends StatefulWidget {
  const ContactsRestScreen({
    required this.api,
    Key? key,
  }) : super(key: key);

  final ContactsRestApi api;

  @override
  State<ContactsRestScreen> createState() => _ContactsRestScreenState();
}

class _ContactsRestScreenState extends State<ContactsRestScreen> {
  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() async {
    final contacts = await widget.api.getContacts();
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  void _addContact() async {
    final faker = Faker();
    final person = faker.person;
    final fullName = '${person.firstName()} ${person.lastName()}';

    final createdContact = await widget.api.addContact(fullName);
    setState(() {
      _contacts.add(createdContact);
    });
  }

  void _deleteContact(String id) async {
    await widget.api.deleteContact(id);
    setState(() {
      _contacts.removeWhere((contact) => contact.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts App'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ContactsListing(
              data: _contacts,
              onAdd: _addContact,
              onDelete: _deleteContact,
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _loadContacts,
            tooltip: 'Refresh list',
            backgroundColor: Colors.purple,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _addContact,
            tooltip: 'Add new contact',
            child: const Icon(Icons.person_add),
          ),
        ],
      ),
    );
  }
}

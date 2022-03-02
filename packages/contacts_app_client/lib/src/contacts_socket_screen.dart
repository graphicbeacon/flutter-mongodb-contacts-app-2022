import 'dart:async';
import 'dart:convert';

import 'package:contacts_app_client/contacts_app_client.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ContactsSocketScreen extends StatefulWidget {
  const ContactsSocketScreen({required this.api, Key? key}) : super(key: key);

  final ContactsSocketApi api;

  @override
  State<ContactsSocketScreen> createState() => _ContactsSocketScreenState();
}

class _ContactsSocketScreenState extends State<ContactsSocketScreen> {
  final _socketStream = StreamController<List<Contact>>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    widget.api
      ..stream.listen((contacts) {
        _isLoading = false;
        _socketStream.add(contacts);
      })
      ..send(json.encode({'action': 'LOAD'}));
  }

  void _addContact() {
    final faker = Faker();
    final person = faker.person;
    final fullName = '${person.firstName()} ${person.lastName()}';

    widget.api.send(json.encode({
      'action': 'ADD',
      'payload': fullName,
    }));
  }

  void _deleteContact(String id) {
    widget.api.send(json.encode({
      'action': 'DELETE',
      'payload': id,
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts App'),
      ),
      body: StreamBuilder<List<Contact>>(
        initialData: const [],
        stream: _socketStream.stream,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ContactsListing(
            data: snapshot.data!,
            onAdd: _addContact,
            onDelete: _deleteContact,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        tooltip: 'Add new contact',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

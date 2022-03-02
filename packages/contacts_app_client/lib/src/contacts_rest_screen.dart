import 'package:flutter/material.dart';

class ContactsRestScreen extends StatefulWidget {
  const ContactsRestScreen({Key? key}) : super(key: key);

  @override
  State<ContactsRestScreen> createState() => _ContactsRestScreenState();
}

class _ContactsRestScreenState extends State<ContactsRestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts App'),
      ),
      body: Container(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Refresh list',
            backgroundColor: Colors.purple,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Add new contact',
            child: const Icon(Icons.person_add),
          ),
        ],
      ),
    );
  }
}

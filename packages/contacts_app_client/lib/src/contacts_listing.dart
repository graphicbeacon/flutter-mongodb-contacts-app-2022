import 'package:flutter/material.dart';
import 'package:contacts_app_client/contacts_app_client.dart';

class ContactsListing extends StatelessWidget {
  const ContactsListing({
    required this.data,
    required this.onAdd,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  final List<Contact> data;
  final VoidCallback onAdd;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? _NoContacts(
            onAdd: onAdd,
          )
        : ListView(
            children: [
              ...data
                  .map<Widget>(
                    (contact) => Padding(
                      key: ValueKey(contact.id),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Text(contact.initials),
                        ),
                        title: Text(
                          contact.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: MaterialButton(
                          onPressed: () {
                            onDelete(contact.id);
                          },
                          child: const Icon(
                            Icons.delete,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          );
  }
}

class _NoContacts extends StatelessWidget {
  const _NoContacts({required this.onAdd, Key? key}) : super(key: key);

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.black45,
          ),
          const Text(
            'No contacts listed',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            color: Colors.purple,
            onPressed: onAdd,
            child: const Text(
              'Add your first',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

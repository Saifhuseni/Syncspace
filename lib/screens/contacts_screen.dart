import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncspace/resource/firestore_methods.dart';
import 'package:syncspace/screens/send_email_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _semController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: true,
        actions: [
          // Email button in the AppBar
          IconButton(
            icon: const Icon(Icons.email),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SendEmailScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Contacts',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _searchController.text;
                    });
                  },
                ),
              ),
            ),
          ),

          // Add Contact Form
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        decoration:
                            const InputDecoration(labelText: 'Phone Number'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _semController,
                        decoration:
                            const InputDecoration(labelText: 'Semester'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _batchController,
                        decoration: const InputDecoration(labelText: 'Batch'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        if (_nameController.text.isNotEmpty &&
                            _phoneController.text.isNotEmpty &&
                            _semController.text.isNotEmpty &&
                            _batchController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty) {
                          await _firestoreMethods.addContact(
                            _nameController.text,
                            _phoneController.text,
                            _semController.text,
                            _batchController.text,
                            _emailController.text,
                          );
                          _nameController.clear();
                          _phoneController.clear();
                          _semController.clear();
                          _batchController.clear();
                          _emailController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Display Contacts
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _searchQuery.isEmpty
                  ? _firestoreMethods.contactsStream
                  : _firestoreMethods.searchContacts(_searchQuery),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final contacts = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      title: Text(contact['name']),
                      subtitle: Text('Phone: ${contact['phoneNumber']}\n'
                          'Semester: ${contact['sem']}, Batch: ${contact['batch']}\n'
                          'Email: ${contact['email']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Contact Button
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditContactDialog(
                                contact.id,
                                contact['name'],
                                contact['phoneNumber'],
                                contact['sem'],
                                contact['batch'],
                                contact['email'],
                              );
                            },
                          ),
                          // Delete Contact Button
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _firestoreMethods.deleteContact(contact.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Edit Contact Dialog
  void _showEditContactDialog(
      String contactId,
      String currentName,
      String currentPhone,
      String currentSem,
      String currentBatch,
      String currentEmail) {
    _nameController.text = currentName;
    _phoneController.text = currentPhone;
    _semController.text = currentSem;
    _batchController.text = currentBatch;
    _emailController.text = currentEmail;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: _semController,
                decoration: const InputDecoration(labelText: 'Semester'),
              ),
              TextField(
                controller: _batchController,
                decoration: const InputDecoration(labelText: 'Batch'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestoreMethods.updateContact(
                  contactId,
                  _nameController.text,
                  _phoneController.text,
                  _semController.text,
                  _batchController.text,
                  _emailController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

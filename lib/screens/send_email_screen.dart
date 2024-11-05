import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SendEmailScreen extends StatefulWidget {
  const SendEmailScreen({super.key});

  @override
  State<SendEmailScreen> createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen> {
  final TextEditingController _semController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Email'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _semController,
              decoration: const InputDecoration(labelText: 'Semester'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _batchController,
              decoration: const InputDecoration(labelText: 'Batch'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendEmailToStudents,
              child: const Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmailToStudents() async {
    final sem = _semController.text.trim();
    final batch = _batchController.text.trim();
    final message = _messageController.text.trim();

    if (sem.isEmpty || batch.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final contacts = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('contacts')
          .where('sem', isEqualTo: sem)
          .where('batch', isEqualTo: batch)
          .get();

      if (contacts.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No contacts found for this semester and batch')),
        );
        return;
      }

      List<String> recipients = [];
      for (var contact in contacts.docs) {
        recipients.add(contact['email']);
      }

      // SMTP Configuration
      String username = '';
      String password = "";

      final smtpServer = SmtpServer('smtp.mailersend.net',
          port: 587,
          username: username,
          password: password,
          ssl: false); // Use TLS

      final messageToSend = Message()
        ..from = Address(username)
        ..recipients.addAll(recipients)
        ..subject = 'Message for Semester $sem, Batch $batch Students'
        ..text = message;

      await send(messageToSend, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sent successfully!')),
      );

      _semController.clear();
      _batchController.clear();
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send email')),
      );
      print(e);
    }
  }
}

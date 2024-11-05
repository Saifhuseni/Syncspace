// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirestoreMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   Stream get meetingsHistory => _firestore.collection('users').doc(_auth.currentUser!.uid).collection('meetings').snapshots();
//   void addMeetingHistory(String meetingName) async {
//     try{
//       await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('meetings').add(
//           {
//             'meetingName': meetingName,
//             'createdAt': DateTime.now(),
//           });
//     }catch(e){
//       print(e);
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get Meeting History
  Stream get meetingsHistory => _firestore.collection('users').doc(_auth.currentUser!.uid).collection('meetings').snapshots();

  // Add Meeting History
  void addMeetingHistory(String meetingName) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('meetings').add({
        'meetingName': meetingName,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Add a new contact
  Future<void> addContact(String name, String phoneNumber, String sem, String batch, String email) async {
    try {
      await _firestore.collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('contacts')
          .add({
        'name': name,
        'phoneNumber': phoneNumber,
        'sem': sem,
        'batch': batch,
        'email': email,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Update contact by document ID
  Future<void> updateContact(String contactId, String name, String phoneNumber, String sem, String batch, String email) async {
    try {
      await _firestore.collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('contacts')
          .doc(contactId)
          .update({
        'name': name,
        'phoneNumber': phoneNumber,
        'sem': sem,
        'batch': batch,
        'email': email,
      });
    } catch (e) {
      print(e);
    }
  }

  // Delete contact by document ID
  Future<void> deleteContact(String contactId) async {
    try {
      await _firestore.collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('contacts')
          .doc(contactId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  // Search contacts by name or phone number
  Stream<QuerySnapshot> searchContacts(String query) {
    return _firestore.collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('contacts')
        .where('name', isGreaterThanOrEqualTo: query)
        .snapshots();
  }

  // Get all contacts
  Stream<QuerySnapshot> get contactsStream {
    return _firestore.collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('contacts')
        .snapshots();
  }
}

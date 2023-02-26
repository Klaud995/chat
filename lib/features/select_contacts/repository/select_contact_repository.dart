import 'package:chat/common/utils/utils.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/features/chat/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SelectContactRepository({
    required this.firestore,
    required this.auth,
  });

  Future<List<UserModel>> getContacts() async {
    List<UserModel> contacts = [];
    try {
      List<Map<String, dynamic>>? listContacts;
      String checkContact;
      var collection = await firestore
          .collection('users')
          .where('uid', isNotEqualTo: auth.currentUser!.uid);
      await collection.get().then((value) {
        value.docs.forEach((element) {
          contacts.add(UserModel.fromMap(element.data()));
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(UserModel selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedUid = selectedContact.uid;
        if (selectedUid == userData.uid) {
          isFound = true;
          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
              'isGroupChat': false,
              'profilePic': userData.profilePic,
            },
          );
        }
      }

      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'Данный пользователь не найден',
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void selectContact2(String uid, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedUid = uid;
        if (selectedUid == userData.uid) {
          isFound = true;
          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
              'isGroupChat': false,
              'profilePic': userData.profilePic,
            },
          );
        }
      }

      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'Данный пользователь не найден',
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

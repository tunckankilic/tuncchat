// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/common/utils/utils.dart';
import 'package:tuncchat/models/user_model.dart';
import 'package:tuncchat/screens/screens.dart';

final SelectContactsRepositoryProvider = Provider(
  (ref) => SelectContactsRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactsRepository {
  final FirebaseFirestore firestore;
  SelectContactsRepository({required this.firestore});

  //Gets device contacts data
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      log(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum = selectedContact.phones[0].number
            .replaceAll(
              ' ',
              '',
            )
            .replaceAll("(", "")
            .replaceAll(")", "")
            .replaceAll("-", "");
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
            },
          );
        }
      }
      if (!isFound) {
        Utils.showSnackBar(
          context: context,
          content: "This number is not registered in the database",
        );
      }
    } catch (e) {
      Utils.showSnackBar(context: context, content: e.toString());
    }
  }
}

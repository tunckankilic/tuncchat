import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/common/repositories/common_firebase_storage_repository.dart';
import 'package:tuncchat/models/status_model.dart';
import 'package:tuncchat/models/user_model.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageurl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );
      log("Break 1");
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
        log("Break 2");
      }

      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: contacts[i]
                    .phones[0]
                    .number
                    .replaceAll(
                      ' ',
                      '',
                    )
                    .replaceAll("(", "")
                    .replaceAll(")", "")
                    .replaceAll("-", ""))
            .get();
        log("Break 3");

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
          log("Break 4");
        }
      }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        log("Break 5");

        return;
      } else {
        statusImageUrls = [imageurl];
      }

      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(statusId).set(status.toMap());
      log("Break 6");
    } catch (e) {
      // Utils.showSnackBar(context: context, content: e.toString());
      log("Error: $e");
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      String? userPhoneNumber = await getUserPhoneNumber();

      if (userPhoneNumber != null) {
        List<Status> userStatuses = await getStatusData(userPhoneNumber);
        statusData.addAll(userStatuses);
      } else {
        log('Kullanıcının numarası Firestore\'da kayıtlı değil.');
      }

      for (int i = 0; i < contacts.length; i++) {
        var phoneNumber = contacts[i]
            .phones[0]
            .number
            .replaceAll(' ', '')
            .replaceAll("(", "")
            .replaceAll(")", "")
            .replaceAll("-", "");
        List<Status> contactStatuses = await getStatusData(phoneNumber);
        statusData.addAll(contactStatuses);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return statusData;
  }

  Future<String?> getUserPhoneNumber() async {
    try {
      var userDoc =
          await firestore.collection('users').doc(auth.currentUser!.uid).get();
      if (userDoc.exists) {
        var userData = userDoc.data();
        return userData?['phoneNumber'];
      }
    } catch (e) {
      log('Hata oluştu: $e');
    }
    return null;
  }

  Future<List<Status>> getStatusData(String phoneNumber) async {
    List<Status> statusData = [];

    try {
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'phoneNumber',
            isEqualTo: phoneNumber,
          )
          .where(
            'createdAt',
            isGreaterThan: DateTime.now()
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
          )
          .get();

      for (var tempData in statusesSnapshot.docs) {
        Status tempStatus = Status.fromMap(tempData.data());
        statusData.add(tempStatus);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }

    return statusData;
  }
}

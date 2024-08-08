// // ignore_for_file: use_build_context_synchronously

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tuncchat/common/utils/utils.dart';
// import 'package:tuncchat/models/call_model.dart';
// import 'package:tuncchat/screens/call/pages/call_screen.dart';

// final callRepositoryProvider = Provider(
//   (ref) => CallRepository(
//     firestore: FirebaseFirestore.instance,
//     auth: FirebaseAuth.instance,
//   ),
// );

// class CallRepository {
//   final FirebaseFirestore firestore;
//   final FirebaseAuth auth;
//   CallRepository({
//     required this.firestore,
//     required this.auth,
//   });

//   Stream<DocumentSnapshot> get callStream =>
//       firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

//   void makeCall(
//     Call senderCallData,
//     BuildContext context,
//     Call receiverCallData,
//   ) async {
//     try {
//       await firestore
//           .collection('call')
//           .doc(senderCallData.callerId)
//           .set(senderCallData.toMap());
//       await firestore
//           .collection('call')
//           .doc(senderCallData.receiverId)
//           .set(receiverCallData.toMap());

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CallScreen(
//             channelId: senderCallData.callId,
//             call: senderCallData,
//             isGroupChat: false,
//           ),
//         ),
//       );
//     } catch (e) {
//       Utils.showSnackBar(context: context, content: e.toString());
//     }
//   }

//   void endCall(
//     String callerId,
//     String receiverId,
//     BuildContext context,
//   ) async {
//     try {
//       await firestore.collection('call').doc(callerId).delete();
//       await firestore.collection('call').doc(receiverId).delete();
//     } catch (e) {
//       Utils.showSnackBar(context: context, content: e.toString());
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const routeName = "/select-contacts";
  const SelectContactsScreen({Key? key}) : super(key: key);

  // void selectContact(
  //     WidgetRef ref, Contact selectedContact, BuildContext context) {
  //   ref.read(selectContactsControllerProvider).selectContact(
  //         selectedContact,
  //         context,
  //       );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contact"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_outlined,
            ),
          ),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: contactList.length,
      //   itemBuilder: (context, index) {
      //     final contact = contactList[index];
      //     return InkWell(
      //       onTap: () {},
      //       child: Padding(
      //         padding: const EdgeInsets.only(bottom: 8.0),
      //         child: ListTile(
      //           leading: contact.photo == null
      //               ? null
      //               : CircleAvatar(
      //                   backgroundImage: MemoryImage(contact.photo!),
      //                   radius: 30,
      //                 ),
      //           title: Text(contact.displayName),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}

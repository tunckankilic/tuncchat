import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/common/widgets/error.dart';
import 'package:tuncchat/common/widgets/loader.dart';
import 'package:tuncchat/screens/contacts/controllers/contacts_controller.dart';
import 'package:tuncchat/utils/colors.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const routeName = "/select-contacts";
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref.read(selectContactsControllerProvider).selectContact(
          selectedContact,
          context,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: textColor,
        ),
        backgroundColor: backgroundColor,
        title: const Text(
          "Select Contact",
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: const [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.search,
          //   ),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.more_vert_outlined,
          //   ),
          // ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return contactSelectorItem(ref, contact, context);
              },
            ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }

  InkWell contactSelectorItem(
      WidgetRef ref, Contact contact, BuildContext context) {
    return InkWell(
      onTap: () => selectContact(ref, contact, context),
      child: Container(
        decoration: const BoxDecoration(
          color: textColor,
          border: Border(
            bottom: BorderSide(color: backgroundColor, width: 2),
          ),
        ),
        child: ListTile(
          leading: contact.photo == null
              ? null
              : CircleAvatar(
                  backgroundImage: MemoryImage(contact.photo!),
                  radius: 30,
                ),
          title: Text(
            contact.displayName,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: backgroundColor,
                ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/screens/contacts/repository/contacts_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactsRepository = ref.watch(SelectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});

final selectContactsControllerProvider = Provider((ref) {
  final selectContactsRepository = ref.watch(SelectContactsRepositoryProvider);
  return SelectContactsController(
    ref: ref,
    selectContactsRepository: selectContactsRepository,
  );
});

class SelectContactsController {
  final ProviderRef ref;
  final SelectContactsRepository selectContactsRepository;
  SelectContactsController({
    required this.ref,
    required this.selectContactsRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactsRepository.selectContact(selectedContact, context);
  }
}

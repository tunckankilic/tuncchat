import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/common/widgets/loader.dart';
import 'package:tuncchat/models/chat_contact.dart';
import 'package:tuncchat/screens/chat/controller/chat_controller.dart';
import 'package:tuncchat/screens/screens.dart';
import 'package:intl/intl.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).chatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var chatContactData = snapshot.data![index];

              return ActiveChatItem(chatContactData: chatContactData);
            },
          );
        },
      ),
    );
  }
}

class ActiveChatItem extends StatelessWidget {
  const ActiveChatItem({
    super.key,
    required this.chatContactData,
  });

  final ChatContact chatContactData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          MobileChatScreen.routeName,
          arguments: {
            'name': chatContactData.name,
            "uid": chatContactData.contactId
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          title: Text(
            chatContactData.name,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              chatContactData.lastMessage,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              chatContactData.profilePic,
            ),
            radius: 30,
          ),
          trailing: Text(
            DateFormat.Hm().format(chatContactData.timeSent),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

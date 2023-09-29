// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/models/user_model.dart';
import 'package:tuncchat/screens/auth/controller/auth_controller.dart';
import 'package:tuncchat/screens/chat/widgets/message_chat_field.dart';

import 'package:tuncchat/utils/utils.dart';
import 'package:tuncchat/widgets/widgets.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = "/mobilechat";
  final String name;
  final String uid;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: textColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: textColor),
        elevation: 0,
        backgroundColor: backgroundColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Text("");
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: textColor),
                ),
                Text(
                  snapshot.data!.isOnline ? "Online" : "Offline",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: textColor),
                )
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.video_call,
              color: textColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              color: textColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: textColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatList(recieverUserId: uid)),
          MessageChatField(recieverUserId: uid),
        ],
      ),
    );
  }
}

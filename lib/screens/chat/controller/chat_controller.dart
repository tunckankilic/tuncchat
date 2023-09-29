import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/common/enums/message_enum.dart';
import 'package:tuncchat/common/providers/message_reply_provider.dart';
import 'package:tuncchat/models/chat_contact.dart';
import 'package:tuncchat/models/message.dart';
import 'package:tuncchat/screens/auth/controller/auth_controller.dart';
import 'package:tuncchat/screens/chat/repository/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({required this.chatRepository, required this.ref});
  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId}) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              recieverUserId: recieverUserId,
              senderUser: value!,
              messageReply: messageReply),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required MessageEnum messageEnum,
    required String recieverUserId,
  }) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              recieverUserId: recieverUserId,
              senderUserData: value!,
              ref: ref,
              messageEnum: messageEnum,
              messageReply: messageReply),
        );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  void sendGifMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
  }) {
    int gifUrlPartIndex = gifUrl.lastIndexOf("-") + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = "https://i.giphy.com/media/$gifUrlPart/200.gif";
    final messageReply = ref.read(messageReplyProvider);

    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendGifMessage(
              context: context,
              gifUrl: newGifUrl,
              recieverUserId: recieverUserId,
              senderUser: value!,
              messageReply: messageReply,
            ));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
      {required BuildContext context,
      required String recieverUserId,
      required String messageId}) {
    chatRepository.setChatMessageSeen(
      context: context,
      recieverUserId: recieverUserId,
      messageId: messageId,
    );
  }
}

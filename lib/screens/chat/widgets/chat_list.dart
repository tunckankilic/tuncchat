import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:tuncchat/common/enums/message_enum.dart';
import 'package:tuncchat/common/providers/message_reply_provider.dart';
import 'package:tuncchat/common/widgets/loader.dart';
import 'package:tuncchat/models/message.dart';
import 'package:tuncchat/screens/chat/controller/chat_controller.dart';
import 'package:tuncchat/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList({
    required this.recieverUserId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  void onMessageSwipe({
    required String message,
    required bool isMe,
    required MessageEnum messageEnum,
  }) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream:
          ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);
            if (!messageData.isSeen &&
                messageData.recieverid ==
                    FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                    context: context,
                    recieverUserId: widget.recieverUserId,
                    messageId: messageData.messageId,
                  );
            }
            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                isSeen: messageData.isSeen,
                repliedText: messageData.repliedMessage,
                repliedMessageType: messageData.repliedMessageType,
                username: messageData.repliedTo,
                onLeftSwipe: () => onMessageSwipe(
                  message: messageData.text,
                  isMe: true,
                  messageEnum: messageData.type,
                ),
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
              );
            }
            return SenderMessageCard(
              repliedText: messageData.repliedMessage,
              repliedMessageType: messageData.repliedMessageType,
              username: messageData.repliedTo,
              onRightSwipe: () => onMessageSwipe(
                message: messageData.text,
                isMe: false,
                messageEnum: messageData.type,
              ),
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
            );
          },
        );
      },
    );
  }
}

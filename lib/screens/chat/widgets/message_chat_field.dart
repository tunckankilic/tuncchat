// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuncchat/common/enums/message_enum.dart';
import 'package:tuncchat/common/providers/message_reply_provider.dart';
import 'package:tuncchat/common/utils/utils.dart';
import 'package:tuncchat/screens/chat/controller/chat_controller.dart';
import 'package:tuncchat/screens/chat/widgets/message_reply.dart';
import 'package:tuncchat/utils/utils.dart';

class MessageChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const MessageChatField({
    super.key,
    required this.recieverUserId,
  });

  @override
  ConsumerState<MessageChatField> createState() => _MessageChatFieldState();
}

class _MessageChatFieldState extends ConsumerState<MessageChatField> {
  bool isShowSendButton = false;
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  bool isRecording = false;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _emojiNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;
  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text,
            recieverUserId: widget.recieverUserId,
          );
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = "${tempDir.path}/flutter_sound.aac";
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void selectImage() async {
    File? image = await Utils.pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void showKeyboard() => _emojiNode.requestFocus();
  void hideKeyboard() => _emojiNode.unfocus();

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          messageEnum: messageEnum,
          recieverUserId: widget.recieverUserId,
        );
  }

  Future<GiphyGif?> pickGif(BuildContext context) async {
    GiphyGif? gif;
    var apiKey = "59dcznYBLV0qYxciLmBPeGsIKm5D86Bx";
    try {
      gif = await Giphy.getGif(context: context, apiKey: apiKey);
    } catch (e) {
      Utils.showSnackBar(context: context, content: e.toString());
    }
    return gif;
  }

  Future<File?> pickVideoFromGallery(BuildContext context) async {
    File? file;
    try {
      final pickedVideo =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        file = File(pickedVideo.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return file;
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGif() async {
    final gif = await pickGif(context);
    if (gif != null) {
      ref.read(chatControllerProvider).sendGifMessage(
            context: context,
            gifUrl: gif.url,
            recieverUserId: widget.recieverUserId,
          );
    }
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.denied) {
      throw RecordingPermissionException("Mid permission not allowed!!");
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyWidget() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                style: const TextStyle(color: backgroundColor),
                focusNode: _emojiNode,
                controller: _messageController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: backgroundColor,
                            ),
                          ),
                          IconButton(
                            onPressed: selectGif,
                            icon: const Icon(
                              Icons.gif,
                              color: backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: backgroundColor,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: backgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  hintStyle: const TextStyle(color: backgroundColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
              child: GestureDetector(
                onTap: () {
                  sendTextMessage();
                  _messageController.clear();
                },
                child: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(5, 96, 98, 1),
                  radius: 25,
                  child: Icon(isShowSendButton
                      ? Icons.send
                      : isRecording
                          ? Icons.close
                          : Icons.mic),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

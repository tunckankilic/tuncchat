// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static void showSnackBar({BuildContext? context, required String content}) {
    if (context != null && context is Element) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(content),
        ),
      );
    }
  }

  static Future<File?> pickImageFromGallery(BuildContext context) async {
    File? image;
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return image;
  }

  static Future<File?> pickVideoFromGallery(BuildContext context) async {
    File? video;
    try {
      final pickedVideo =
          await ImagePicker().pickVideo(source: ImageSource.gallery);

      if (pickedVideo != null) {
        video = File(pickedVideo.path);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return video;
  }
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: '59dcznYBLV0qYxciLmBPeGsIKm5D86Bx',
    );
  } catch (e) {
    Utils.showSnackBar(context: context, content: e.toString());
  }
  return gif;
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    Utils.showSnackBar(context: context, content: e.toString());
  }
  return image;
}

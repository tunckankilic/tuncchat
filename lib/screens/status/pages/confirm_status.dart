// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/screens/status/controller/controller.dart';
import 'package:tuncchat/utils/utils.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const String routeName = "/confirm-status";
  final File file;
  const ConfirmStatusScreen({
    super.key,
    required this.file,
  });

  void addStatus({required WidgetRef ref, required BuildContext context}) {
    ref.read(statusControllerProvider).addStatus(
          file: file,
          context: context,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addStatus(ref: ref, context: context);
        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}

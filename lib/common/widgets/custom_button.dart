import 'package:flutter/material.dart';
import 'package:tuncchat/common/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final Color? bgColor;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.bgColor = Colors.black,
    this.textStyle = const TextStyle(
      color: blackColor,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: textColor,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0.0,
        backgroundColor: bgColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}

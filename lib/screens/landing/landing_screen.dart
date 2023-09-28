import 'package:flutter/material.dart';

import 'package:tuncchat/utils/utils.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = "/landing";
  const LandingScreen({Key? key}) : super(key: key);

  // void navigateToLoginScreen(BuildContext context) {
  //   Navigator.pushNamed(context, LoginScreen.routeName);
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome to TKChat',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: size.height / 28),
            Image.asset(
              'assets/bg.png',
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(height: size.height / 28),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                style: TextStyle(color: Colors.grey[900]!),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            // SizedBox(
            //   width: size.width * 0.75,
            //   child: CustomButton(
            //     text: 'AGREE AND CONTINUE',
            //     onPressed: () => navigateToLoginScreen(context),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

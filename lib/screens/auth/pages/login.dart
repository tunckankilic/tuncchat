// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/common/utils/utils.dart';
import 'package:tuncchat/common/widgets/custom_button.dart';
import 'package:tuncchat/screens/auth/controller/auth_controller.dart';
import 'package:tuncchat/utils/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      Utils.showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: textColor),
        title: const Text(
          'Enter your phone number',
          style: TextStyle(
            color: textColor,
          ),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'WhatsApp will need to verify your phone number.',
                style: TextStyle(
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  pickCountry();
                },
                child: const Text(
                  'Pick Country',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  if (country != null)
                    Text(
                      '+${country!.phoneCode}',
                      style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: textColor,
                        width: 2,
                      ),
                    ),
                    width: size.width * 0.7,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          color: textColor,
                        ),
                        hintText: ' Phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.5),
              CustomButton(
                bgColor: backgroundColor,
                onPressed: sendPhoneNumber,
                text: 'NEXT',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

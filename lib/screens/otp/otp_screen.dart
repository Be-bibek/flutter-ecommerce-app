import 'package:flutter/material.dart';

import '../../components/glass_morphism_utils.dart';
import '../../constants.dart';

import 'components/otp_form.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  final String email;
  final String? name;
  final String? phone;
  final String? providerType;
  const OtpScreen({super.key, required this.email, this.name, this.phone, this.providerType});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
                Text("We sent your code to $email"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("This code will expired in "),
                    TweenAnimationBuilder(
                      tween: Tween(begin: 30.0, end: 0.0),
                      duration: const Duration(seconds: 30),
                      builder: (_, dynamic value, child) => Text(
                        "00: ${value.toInt()}",
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
                OtpForm(email: email, name: name, phone: phone, providerType: providerType),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // OTP code resend
                  },
                  child: const Text(
                    "Resend OTP Code",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../components/glass_morphism_utils.dart';
import '../../../constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../otp/otp_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? name;
  String? phone;
  String? providerType;
  final List<String?> errors = [];
  bool isLoading = false;

  final List<String> providerTypes = [
    'Individual',
    'Business',
    'Other',
  ];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (newValue) => name = newValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Name",
              hintText: "Enter your name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phone = newValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (!RegExp(r'^\d{10,15}').hasMatch(value)) {
                return 'Enter a valid phone number';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter your phone number",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: providerType,
            items: providerTypes
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                providerType = value;
              });
            },
            validator: (value) => value == null ? 'Select provider type' : null,
            decoration: const InputDecoration(
              labelText: "Provider Type",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          const SizedBox(height: 16),
          isLoading
              ? const CircularProgressIndicator()
              : GlassMorphismUtils.buildPrimaryGlassButton(
                  text: "Send Magic Link / OTP",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() { isLoading = true; });
                      try {
                        await Supabase.instance.client.auth.signInWithOtp(
                          email: email!,
                          emailRedirectTo: null, // or your custom redirect URL
                        );
                        setState(() { isLoading = false; });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Check your email for the magic link or OTP.')),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                              email: email!,
                              name: name,
                              phone: phone,
                              providerType: providerType,
                            ),
                          ),
                        );
                      } catch (e) {
                        setState(() { isLoading = false; });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
        ],
      ),
    );
  }
}

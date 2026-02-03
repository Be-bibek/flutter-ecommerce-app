import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../components/glass_morphism_utils.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../forgot_password/forgot_password_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../otp/otp_screen.dart';
import '../../init_screen.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  final List<String?> errors = [];
  bool isLoading = false;

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
                  text: "Continue",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      KeyboardUtil.hideKeyboard(context);
                      setState(() { isLoading = true; });
                      
                      // Check if it's the dev email
                      if (email == "mydevemail@example.com") {
                        try {
                          // For dev email, we'll skip the actual authentication
                          // and just create a session manually
                          
                          // Simulate a delay for loading effect
                          await Future.delayed(const Duration(milliseconds: 500));
                          
                          setState(() { isLoading = false; });
                          
                          // Show dev login success toast using Fluttertoast directly
                          Fluttertoast.showToast(
                            msg: "Dev login successful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: kPrimaryColor,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                          
                          // Navigate to home screen
                          Navigator.pushNamedAndRemoveUntil(
                            context, 
                            InitScreen.routeName, 
                            (route) => false
                          );
                        } catch (e) {
                          setState(() { isLoading = false; });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      } else {
                        // Normal OTP flow for other emails
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
                              builder: (context) => OtpScreen(email: email!),
                            ),
                          );
                        } catch (e) {
                          setState(() { isLoading = false; });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      }
                    }
                  },
                ),
          const SizedBox(height: 16),
          GlassMorphismUtils.buildPrimaryGlassButton(
            text: "Continue as Guest",
            onPressed: () {
              KeyboardUtil.hideKeyboard(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                InitScreen.routeName,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

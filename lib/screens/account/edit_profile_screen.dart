import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/form_error.dart';
import '../../constants.dart';
import '../../helper/keyboard.dart';

class EditProfileScreen extends StatefulWidget {
  static String routeName = "/edit_profile";

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isSaving = false;
  Map<String, dynamic>? profileData;
  String? error;
  
  // Form fields
  String? name;
  String? email;
  String? phone;
  
  // Error handling
  final List<String?> errors = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setState(() {
          error = "User not logged in";
          isLoading = false;
        });
        return;
      }

      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        profileData = response;
        name = profileData?['name'];
        email = profileData?['email'];
        phone = profileData?['phone'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

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

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    _formKey.currentState!.save();
    KeyboardUtil.hideKeyboard(context);
    
    setState(() {
      isSaving = true;
    });
    
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      
      await Supabase.instance.client
          .from('profiles')
          .update({
            'name': name,
            'phone': phone,
            // Email is typically managed by auth system, not directly updated in profile
          })
          .eq('id', user.id);
      
      setState(() {
        isSaving = false;
      });
      
      Fluttertoast.showToast(
        msg: "Profile updated successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      
      Navigator.pop(context, true); // Return true to indicate successful update
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      
      Fluttertoast.showToast(
        msg: "Error updating profile: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text("Error: $error"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildNameField(),
                        const SizedBox(height: 20),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPhoneField(),
                        const SizedBox(height: 20),
                        FormError(errors: errors),
                        const SizedBox(height: 20),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: name,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Full Name",
        hintText: "Enter your full name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: SvgPicture.asset(
            "assets/icons/User.svg",
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      initialValue: email,
      keyboardType: TextInputType.emailAddress,
      enabled: false, // Email is typically managed by auth system, not directly updated
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: SvgPicture.asset(
            "assets/icons/Mail.svg",
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(kSecondaryColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      initialValue: phone,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: SvgPicture.asset(
            "assets/icons/Phone.svg",
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSaving ? null : _saveProfile,
        child: isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Save Changes"),
      ),
    );
  }
}
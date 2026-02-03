import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';

class AccountScreen extends StatefulWidget {
  static String routeName = "/account";

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isLoading = true;
  Map<String, dynamic>? profileData;
  String? error;

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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text("Error: $error"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Account Information",
                        style: headingStyle,
                      ),
                      const SizedBox(height: 20),
                      _buildProfileCard(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                              context, 
                              '/edit_profile',
                            );
                            
                            // Reload profile data if changes were made
                            if (result == true) {
                              _loadProfileData();
                            }
                          },
                          child: const Text("Edit"),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            "assets/icons/User.svg",
            "Full Name",
            profileData?['name'] ?? "Not available",
          ),
          const Divider(height: 30),
          _buildInfoRow(
            "assets/icons/Mail.svg",
            "Email Address",
            profileData?['email'] ?? "Not available",
          ),
          const Divider(height: 30),
          _buildInfoRow(
            "assets/icons/Phone.svg",
            "Phone Number",
            profileData?['phone'] ?? "Not available",
          ),
          const Divider(height: 30),
          _buildInfoRow(
            "assets/icons/Settings.svg",
            "Provider Type",
            profileData?['provider_type'] ?? "Not available",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String iconPath, String label, String value) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 22,
          height: 22,
          color: kPrimaryColor,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: kSecondaryColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
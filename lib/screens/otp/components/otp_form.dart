import 'dart:async';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../home/home_screen.dart';

class OtpForm extends StatefulWidget {
  final String email;
  final String? name;
  final String? phone;
  final String? providerType;
  const OtpForm({Key? key, required this.email, this.name, this.phone, this.providerType}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  bool isLoading = false;
  bool isResending = false;
  int resendCooldown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown > 0) {
        setState(() {
          resendCooldown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void nextField(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.length == 0 && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit OTP.')),
      );
      return;
    }
    setState(() { isLoading = true; });
    try {
      final res = await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.email,
      );
      setState(() { isLoading = false; });
      if (res.session != null) {
        // If extra fields are present, insert into profiles table
        if (widget.name != null && widget.phone != null && widget.providerType != null) {
          final userId = res.session!.user.id;
          await Supabase.instance.client.from('profiles').upsert({
            'id': userId,
            'email': widget.email,
            'name': widget.name,
            'phone': widget.phone,
            'provider_type': widget.providerType,
          });
        }
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP or session.')),
        );
      }
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error:  ${e.toString()}')),
      );
    }
  }

  Future<void> resendOtp() async {
    setState(() { isResending = true; });
    try {
      await Supabase.instance.client.auth.signInWithOtp(email: widget.email);
      setState(() {
        isResending = false;
        resendCooldown = 60;
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (resendCooldown > 0) {
          setState(() {
            resendCooldown--;
          });
        } else {
          timer.cancel();
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent! Check your email.')),
      );
    } catch (e) {
      setState(() { isResending = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resending OTP:  ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) => SizedBox(
              width: 45,
              child: TextFormField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                autofocus: i == 0,
                obscureText: true,
                style: const TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: otpInputDecoration.copyWith(counterText: ''),
                onChanged: (value) => nextField(value, i),
              ),
            )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: verifyOtp,
                  child: const Text("Continue"),
                ),
          const SizedBox(height: 16),
          isResending
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: resendCooldown > 0 ? null : resendOtp,
                  child: resendCooldown > 0
                      ? Text('Resend OTP (${resendCooldown}s)')
                      : const Text('Resend OTP'),
                ),
        ],
      ),
    );
  }
}

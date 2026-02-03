import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../components/glass_morphism_utils.dart';

class PaymentScreen extends StatefulWidget {
  static String routeName = "/payment";

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay? _razorpay;
  String _paymentStatus = '';

  @override
  void initState() {
    super.initState();
    // Only initialize Razorpay on mobile platforms
    if (!kIsWeb) {
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }

  void _openCheckout() async {
    if (kIsWeb) {
      // Handle web payment - show demo payment success
      setState(() {
        _paymentStatus = 'Web Payment Demo - Payment Successful!';
      });
      
      // Show success dialog for web
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Demo'),
          content: const Text('This is a demo payment for web platform. In production, you would integrate with Razorpay Web SDK or other web payment solutions.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Mobile platform - use Razorpay
    var options = {
      'key': 'rzp_test_fUzgkYXPSl2m1P', ///// TODO: Replace with your Razorpay key id
      'amount': 33715, // Amount in paise (₹337.15)
      'name': 'E-Commerce App',
      'description': 'Cart Payment',
      'prefill': {'contact': '9051776463', 'email': 'bibek@gmal.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        _paymentStatus = 'Error: $e';
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _paymentStatus = 'Payment Successful: ${response.paymentId}';
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _paymentStatus = 'Payment Failed: ${response.code} - ${response.message}';
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _paymentStatus = 'External Wallet Selected: ${response.walletName}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassMorphismUtils.buildPrimaryGlassButton(
              text: 'Pay with Razorpay',
              onPressed: _openCheckout,
            ),
            const SizedBox(height: 20),
            Text(_paymentStatus),
          ],
        ),
      ),
    );
  }
} 
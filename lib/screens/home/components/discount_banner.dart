import 'package:flutter/material.dart';
import '../../../components/glass_morphism_utils.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: GlassMorphismUtils.buildGlassContainer(
        borderRadius: 20,
        blur: 25,
        color: const Color(0xFF4A3298).withOpacity(0.3),
        borderColor: const Color(0xFF4A3298).withOpacity(0.4),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Text.rich(
          TextSpan(
            style: GlassMorphismUtils.getGlassTextStyle(
              const TextStyle(color: Colors.white),
              shadowColor: Colors.black54,
              shadowBlurRadius: 3,
            ),
            children: [
              const TextSpan(text: "A Summer Surpise\n"),
              TextSpan(
                text: "Cashback 20%",
                style: GlassMorphismUtils.getGlassTextStyle(
                  const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  shadowColor: Colors.black54,
                  shadowBlurRadius: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

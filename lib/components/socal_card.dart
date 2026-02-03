import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'glass_morphism_utils.dart';

class SocalCard extends StatelessWidget {
  const SocalCard({
    Key? key,
    this.icon,
    this.press,
  }) : super(key: key);

  final String? icon;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: GlassMorphismUtils.buildGlassButton(
        onPressed: press as void Function(),
        borderRadius: 20,
        blur: 15,
        color: const Color(0xFFF5F6F9).withOpacity(0.3),
        borderColor: Colors.white.withOpacity(0.4),
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 16,
          width: 16,
          child: SvgPicture.asset(icon!),
        ),
      ),
    );
  }
}

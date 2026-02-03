import 'package:flutter/material.dart';

import '../constants.dart';
import 'glass_morphism_utils.dart';

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key? key,
    required this.icon,
    required this.press,
    this.showShadow = false,
  }) : super(key: key);

  final IconData icon;
  final GestureTapCancelCallback press;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: GlassMorphismUtils.buildGlassButton(
        onPressed: press,
        borderRadius: 20,
        blur: 15,
        color: Colors.white.withOpacity(0.25),
        borderColor: Colors.white.withOpacity(0.4),
        padding: EdgeInsets.zero,
        child: Icon(
          icon,
          color: kPrimaryColor,
          size: 18,
        ),
      ),
    );
  }
}

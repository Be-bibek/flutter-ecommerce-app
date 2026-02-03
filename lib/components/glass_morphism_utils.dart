import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class GlassMorphismUtils {
  // Standard glass container for cards and main components
  static Widget buildGlassContainer({
    required Widget child,
    double borderRadius = 20,
    double blur = 20,
    Color? color,
    Color? borderColor,
    double borderWidth = 1.5,
    double elevation = 3,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.25),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // Glass container for app bars
  static Widget buildGlassAppBar({
    required Widget child,
    double borderRadius = 0,
    double blur = 15,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // Glass container for buttons (using stable Container implementation)
  static Widget buildGlassButton({
    required Widget child,
    required VoidCallback onPressed,
    double borderRadius = 12,
    double blur = 15,
    Color? color,
    Color? borderColor,
    double borderWidth = 1.5,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? Colors.white.withOpacity(0.25),
            width: borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  // Primary glass button (for Login, Sign Up, etc.)
  static Widget buildPrimaryGlassButton({
    required String text,
    required VoidCallback onPressed,
    double borderRadius = 12,
    double blur = 15,
    Color? color,
    Color? textColor,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return buildGlassButton(
      onPressed: onPressed,
      borderRadius: borderRadius,
      blur: blur,
      color: color ?? Colors.blue.withOpacity(0.3),
      borderColor: Colors.blue.withOpacity(0.4),
      child: Center(
        child: Text(
          text,
          style: getGlassTextStyle(
            TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }

  // Secondary glass button (for Cancel, Back, etc.)
  static Widget buildSecondaryGlassButton({
    required String text,
    required VoidCallback onPressed,
    double borderRadius = 12,
    double blur = 15,
    Color? color,
    Color? textColor,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return buildGlassButton(
      onPressed: onPressed,
      borderRadius: borderRadius,
      blur: blur,
      color: color ?? Colors.white.withOpacity(0.15),
      borderColor: Colors.white.withOpacity(0.3),
      child: Center(
        child: Text(
          text,
          style: getGlassTextStyle(
            TextStyle(
              color: textColor ?? Colors.black87,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }

  // Glass text button (for links, subtle actions)
  static Widget buildGlassTextButton({
    required String text,
    required VoidCallback onPressed,
    Color? textColor,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: getGlassTextStyle(
          TextStyle(
            color: textColor ?? Colors.blue,
            fontWeight: fontWeight,
            fontSize: fontSize,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  // Glass container for product cards
  static Widget buildGlassProductCard({
    required Widget child,
    double borderRadius = 16,
    double blur = 20,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // Glass container for input fields
  static Widget buildGlassInputField({
    required Widget child,
    double borderRadius = 28,
    double blur = 15,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: blur / 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  // Text style with shadow for better readability on glass
  static TextStyle getGlassTextStyle(TextStyle baseStyle, {
    Color shadowColor = Colors.black26,
    double shadowBlurRadius = 2,
    Offset shadowOffset = const Offset(0, 1),
  }) {
    return baseStyle.copyWith(
      shadows: [
        Shadow(
          color: shadowColor,
          blurRadius: shadowBlurRadius,
          offset: shadowOffset,
        ),
      ],
    );
  }

  // Responsive text handling utilities
  static Widget buildResponsiveText({
    required String text,
    required TextStyle style,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
    bool softWrap = true,
    bool useFittedBox = false,
  }) {
    Widget textWidget = Text(
      text,
      style: getGlassTextStyle(style),
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
    
    return useFittedBox ? FittedBox(child: textWidget) : textWidget;
  }

  // Responsive row with overflow handling
  static Widget buildResponsiveRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool useScrollView = false,
  }) {
    if (useScrollView) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      );
    }
    
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children.map((child) => Flexible(child: child)).toList(),
    );
  }

  // Responsive column with proper spacing
  static Widget buildResponsiveColumn({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = 8.0,
  }) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }
    
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacedChildren,
    );
  }

  // Glass background for screens
  static Widget buildGlassBackground({
    required Widget child,
    Color? backgroundColor,
    String? backgroundImage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF8F9FA),
        image: backgroundImage != null
            ? DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8),
                  BlendMode.overlay,
                ),
              )
            : null,
      ),
      child: child,
    );
  }

  // Colors for dark theme compatibility
  static Color getDarkThemeGlassColor() => Colors.black.withOpacity(0.2);
  static Color getDarkThemeGlassBorder() => Colors.white.withOpacity(0.1);
  static Color getLightThemeGlassColor() => Colors.white.withOpacity(0.2);
  static Color getLightThemeGlassBorder() => Colors.white.withOpacity(0.3);
}

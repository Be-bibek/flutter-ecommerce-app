import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../components/glass_morphism_utils.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/Flash Icon.svg", "text": "Flash Deal"},
      {"icon": "assets/icons/Bill Icon.svg", "text": "Bill"},
      {"icon": "assets/icons/Game Icon.svg", "text": "Game"},
      {"icon": "assets/icons/Gift Icon.svg", "text": "Daily Gift"},
      {"icon": "assets/icons/Discover.svg", "text": "More"},
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {},
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          GlassMorphismUtils.buildGlassContainer(
            borderRadius: 14,
            blur: 15,
            color: const Color(0xFFFFECDF).withOpacity(0.3),
            borderColor: const Color(0xFFFFECDF).withOpacity(0.5),
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 24,
              width: 24,
              child: SvgPicture.asset(icon),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text, 
            textAlign: TextAlign.center,
            style: GlassMorphismUtils.getGlassTextStyle(
              const TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}

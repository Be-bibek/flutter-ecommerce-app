import 'package:flutter/material.dart';
import 'package:shop_app/screens/products/products_screen.dart';

import 'section_title.dart';
import '../../../components/glass_morphism_utils.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Special for you",
            press: () {},
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                image: "assets/images/Image Banner 2.png",
                category: "Smartphone",
                numOfBrands: 18,
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
              SpecialOfferCard(
                image: "assets/images/Image Banner 3.png",
                category: "Fashion",
                numOfBrands: 24,
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242,
          height: 100,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              GlassMorphismUtils.buildGlassContainer(
                borderRadius: 20,
                blur: 20,
                color: Colors.black.withOpacity(0.3),
                borderColor: Colors.white.withOpacity(0.2),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: GlassMorphismUtils.getGlassTextStyle(
                        const TextStyle(color: Colors.white),
                        shadowColor: Colors.black87,
                        shadowBlurRadius: 4,
                      ),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: GlassMorphismUtils.getGlassTextStyle(
                            const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            shadowColor: Colors.black87,
                            shadowBlurRadius: 4,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Brands")
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import '../models/Product.dart';
import 'glass_morphism_utils.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final VoidCallback onPress;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.isFavourite;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      // Note: Can't modify final property widget.product.isFavourite
      // In a real app, you would save this to a database or state management
    });
    
    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite 
            ? '${widget.product.title} added to favorites!' 
            : '${widget.product.title} removed from favorites!',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: isFavorite ? Colors.green : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        onTap: widget.onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: GlassMorphismUtils.buildGlassProductCard(
                borderRadius: 16,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(widget.product.images[0]),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                widget.product.title,
                style: GlassMorphismUtils.getGlassTextStyle(
                  Theme.of(context).textTheme.bodyMedium!,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${widget.product.price}",
                  style: GlassMorphismUtils.getGlassTextStyle(
                    const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: _toggleFavorite,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: GlassMorphismUtils.buildGlassContainer(
                      borderRadius: 12,
                      blur: 15,
                      color: isFavorite
                          ? kPrimaryColor.withOpacity(0.2)
                          : Colors.white.withOpacity(0.2),
                      borderColor: isFavorite
                          ? kPrimaryColor.withOpacity(0.3)
                          : Colors.white.withOpacity(0.3),
                      padding: const EdgeInsets.all(6),
                      child: SizedBox(
                        height: 12,
                        width: 12,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: SvgPicture.asset(
                            "assets/icons/Heart Icon_2.svg",
                            key: ValueKey(isFavorite),
                            colorFilter: ColorFilter.mode(
                                isFavorite
                                    ? const Color(0xFFFF4848)
                                    : const Color(0xFFDBDEE4),
                                BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

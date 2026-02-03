import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../components/glass_morphism_utils.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassMorphismUtils.buildGlassInputField(
      borderRadius: 16,
      child: TextFormField(
        onChanged: (value) {},
        style: GlassMorphismUtils.getGlassTextStyle(
          const TextStyle(color: Colors.black87),
        ),
        decoration: InputDecoration(
          filled: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: "Search product",
          hintStyle: GlassMorphismUtils.getGlassTextStyle(
            TextStyle(color: Colors.black54),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);

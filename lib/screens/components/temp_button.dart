import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';

class TempButton extends StatelessWidget {
  final String svgSrc, title;
  final bool isActive;
  final VoidCallback press;
  final Color activeColor;
  const TempButton({
    required this.svgSrc,
    required this.title,
    this.isActive = false,
    required this.press,
    this.activeColor = kPrimaryColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutBack,
            height: isActive ? 76 : 50,
            width: isActive ? 76 : 50,
            child: SvgPicture.asset(svgSrc),
            color: isActive ? activeColor : Colors.white38,
          ),
          const SizedBox(height: kPadding / 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 16,
              color: isActive ? activeColor : Colors.white38,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            child: Text(
              title.toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }
}
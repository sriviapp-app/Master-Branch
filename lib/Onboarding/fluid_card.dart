import 'package:flutter/material.dart';

class FluidCard extends StatelessWidget {
  final Color color;
  final Color altColor;
  final String bgImage;
  final String? topImage; // 👈 new: path for image above title
  final String? title;
  final String? subtitle;
  final Widget? child;

  const FluidCard({
    super.key,
    required this.color,
    required this.altColor,
    required this.bgImage,
    this.topImage,
    this.title,
    this.subtitle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: child ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (topImage != null) ...[
                  Image.asset(
                    topImage!,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                ],
                if (title != null && title!.isNotEmpty)
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
      ),
    );
  }
}

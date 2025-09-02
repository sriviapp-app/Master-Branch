import 'package:flutter/material.dart';

class FluidCard extends StatelessWidget {
  final Color color;
  final Color altColor;
  final String bgImage;
  final String? title;
  final String? subtitle;
  final Widget? child; // 👈 new

  const FluidCard({
    super.key,
    required this.color,
    required this.altColor,
    required this.bgImage,
    this.title,
    this.subtitle,
    this.child, // 👈 new
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

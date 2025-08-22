import 'package:flutter/material.dart';

// Premium gradient colors
const Color kPrimaryColor = Color(0xFF3A8DFF); // Blue
const Color kSecondaryColor = Color(0xFF6C63FF); // Purple

const LinearGradient kAppGradient = LinearGradient(
  colors: [kPrimaryColor, kSecondaryColor],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Reusable: Gradient AppBar
PreferredSizeWidget gradientAppBar(String title) {
  return AppBar(
    title: Text(title),
    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(gradient: kAppGradient),
    ),
  );
}

// Reusable: Gradient pill/button container
Widget gradientButton({
  required String label,
  IconData? icon,
  required VoidCallback onTap,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  ),
  double radius = 12,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: kAppGradient,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

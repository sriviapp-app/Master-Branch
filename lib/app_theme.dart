import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightPrimary = Color(0xFF6757ED);   // Cyan-Blue
  static const Color lightSecondary = Color(0xFF9575CD); // Blue-Purple
  static const Color lightAccent = Color(0xFFFFD54F);    // Vibrant Purple
  static const Color lightBackground = Color(0xFFE3F2FD); // Very light bluish background

// Dark mode (deep & premium)
  static const Color darkPrimary = Color(0xFF3598F3);    // Medium Blue
  static const Color darkSecondary = Color(0xFF6757ED);  // Deep Purple
  static const Color darkAccent = Color(0xFF9029E6);     // Bright Purple
  static const Color darkBackground = Color(0xFF0D0D33);

  static const LinearGradient lightGradient = LinearGradient(
    colors: [lightPrimary, lightSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Dark Gradient
  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkPrimary, darkSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  PreferredSizeWidget gradientAppBar(BuildContext context, String title) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(title),
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
        ),
      ),
    );
  }

  // Text styles
  static const TextStyle splashTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle splashSubtitle = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  // Button Gradient
  static LinearGradient buttonGradient({required bool isDarkMode}) {
    return isDarkMode ? darkGradient : lightGradient;
  }

  // App ThemeData
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimary,
      foregroundColor: lightAccent,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      bodyLarge: TextStyle(color: Colors.black87),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimary,
      foregroundColor: darkAccent,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white70),
    ),
  );
}

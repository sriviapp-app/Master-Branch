import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:namma_srivi/Dashboard/dashboard_screen.dart';
import 'package:namma_srivi/Onboarding/splash_screen.dart';
 // your onboarding

import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'package:namma_srivi/Onboarding/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Own App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // auto follow system theme
      home: const SplashScreen(),
    );
  }
}




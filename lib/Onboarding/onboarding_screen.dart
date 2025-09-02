import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'fluid_card.dart';
import 'fluid_carousel.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../Dashboard/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late LiquidController _controller;
  int _currentIndex = 0;

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  final List<Color> _dotColors = [
    const Color(0xFF3BD6F0),
    const Color(0xFF17C8FC),
    const Color(0xFF27AFF9),
  ];

  @override
  void initState() {
    super.initState();
    _controller = LiquidController();

    // Pre-cache background images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var img in [
        "images/Bg-Yellow.png",
        "images/Bg-Red.png",
        "images/Bg-Blue.png",
      ]) {
        precacheImage(AssetImage(img), context);
      }
    });
  }

  void _nextPage() {
    if (_currentIndex < 2) {
      _controller.animateToPage(page: _currentIndex + 1, duration: 300);
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _controller.animateToPage(page: _currentIndex - 1, duration: 300);
    }
  }

  Future<void> _finishOnboarding() async {
    final mobile = _mobileController.text.trim();
    final name = _nameController.text.trim();

    if (mobile.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid mobile number")),
      );
      return;
    }
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter name")),
      );
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showAlert("No Internet", "Please check your connection and try again.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      final response = await http.get(
        Uri.parse(
          "https://gist.githubusercontent.com/sriviapp-app/1662d1b32d0d7b85612e2d50d4051660/raw/config.json",
        ),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        await _storage.write(key: "mobile", value: mobile);
        await _storage.write(key: "name", value: name);
        await _storage.write(key: "loginResponse", value: response.body);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } else {
        _showAlert("Login Failed", "Invalid response. Please try again.");
      }
    } catch (e) {
      Navigator.pop(context);
      _showAlert("Error", "Something went wrong. Please try again.");
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FluidCarousel(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: [
              const FluidCard(
                color: Color(0xFFFFB138),
                altColor: Color(0xFFFFD580),
                bgImage: "images/Bg-Yellow.png",
                topImage: "images/Temple_Nearby.png", // 👈 image above title
                title: "Sleep Soundly \nwith Soothing Stories",
                subtitle: "Drift into deep sleep with relaxing bedtime stories.",
              ),
              const FluidCard(
                color: Color(0xFF904E93),
                altColor: Color(0xFFDA8BD3),
                bgImage: "images/Bg-Red.png",
                topImage: "images/palkova.jpg",
                title: "Refresh Your Mind \nwith Guided Breathing",
                subtitle: "Reduce stress and boost focus with breathing techniques.",
              ),
              // Last card with input fields
              FluidCard(
                color: const Color(0xFF4259B2),
                altColor: const Color(0xFF6A85B6),
                bgImage: "images/Bg-Blue.png",
                topImage: "images/Need help.png",
                child: OnboardingInputFields(
                  nameController: _nameController,
                  mobileController: _mobileController,
                  onLogin: _finishOnboarding,
                ),
              ),
            ],
          ),

          // Dot indicators
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final color = _dotColors[index % _dotColors.length];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? color
                        : color.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          // Prev / Next Buttons
          if (_currentIndex > 0)
            Positioned(
              bottom: 80,
              left: 20,
              child: FloatingActionButton(
                heroTag: "prevBtn",
                backgroundColor: Colors.white,
                elevation: 6,
                onPressed: _previousPage,
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          if (_currentIndex < 2)
            Positioned(
              bottom: 80,
              right: 20,
              child: FloatingActionButton(
                heroTag: "nextBtn",
                backgroundColor: Colors.white,
                elevation: 6,
                onPressed: _nextPage,
                child: const Icon(Icons.arrow_forward, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}

// Separate widget for input fields with scrollable keyboard handling
class OnboardingInputFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final VoidCallback onLogin;

  const OnboardingInputFields({
    super.key,
    required this.nameController,
    required this.mobileController,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            reverse: true, // Scroll up when keyboard opens
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "Start Your Day \nwith Peaceful Mornings",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Wake up refreshed with calming nature-inspired sounds.",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        prefixIcon: const Icon(Icons.account_circle_rounded),
                        hintText: "Enter your name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: mobileController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "🇮🇳",
                            style: TextStyle(fontSize: 28),
                          ),
                        ),
                        hintText: "Enter mobile number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

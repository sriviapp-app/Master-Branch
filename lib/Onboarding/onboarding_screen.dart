import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'fluid_card.dart';
import 'fluid_carousel.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import '../Dashboard/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<OnboardingScreen> {
  late LiquidController _controller;
  int _currentIndex = 0;

  // Persistent controllers for login fields
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final _storage = const FlutterSecureStorage();

  // App icon gradient colors for dot indicators
  final List<Color> _dotColors = [
    Color(0xFF3BD6F0),
    Color(0xFF17C8FC),
    Color(0xFF27AFF9),
    Color(0xFF3598F3),
    Color(0xFF487DED),
    Color(0xFF5E60EC),
    Color(0xFF6757ED),
    Color(0xFF7F3EEA),
    Color(0xFF8C2BEA),
    Color(0xFF9029E6),
  ];

  @override
  void initState() {
    super.initState();
    _controller = LiquidController();
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

  void _finishOnboarding() async {
    final mobile = _mobileController.text.trim();
    final name = _nameController.text.trim();

    if (mobile.length < 10) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter valid mobile number")));
      return;
    }
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter name")));
      return;
    }

    // Save user info
    await _storage.write(key: "mobile", value: mobile);
    await _storage.write(key: "name", value: name);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FluidCarousel(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: <Widget>[
              const FluidCard(
                color: Color(0xFFFFB138),
                altColor: Color(0xFFFFD580),
                bgImage: "images/Bg-Yellow.png",
                title: "Sleep Soundly \nwith Soothing Stories",
                subtitle: "Drift into deep sleep with relaxing bedtime stories.",
              ),
              const FluidCard(
                color: Color(0xFF904E93),
                altColor: Color(0xFFDA8BD3),
                bgImage: "images/Bg-Red.png",
                title: "Refresh Your Mind \nwith Guided Breathing",
                subtitle: "Reduce stress and boost focus with breathing techniques.",
              ),
              FluidCard(
                color: const Color(0xFF4259B2),
                altColor: const Color(0xFF6A85B6),
                bgImage: "images/Bg-Blue.png",
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Start Your Day \nwith Peaceful Mornings",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          prefixIcon: const Icon(Icons.account_circle_rounded),
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _mobileController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          prefixIcon: Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: const Text(
                              "🇮🇳",
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                          hintText: "Enter mobile number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _finishOnboarding,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
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
                // pick gradient color based on index
                final color = _dotColors[(index * 3) % _dotColors.length];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? color : color.withOpacity(0.4),
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
                child: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
              ),
            ),
        ],
      ),
    );
  }
}

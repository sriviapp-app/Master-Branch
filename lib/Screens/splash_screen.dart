import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:namma_srivi/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  bool _showLogin = false;
  Alignment _logoAlign = Alignment.center;

  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  final List<String> cities = [
    "Srivilliputhur",
    "Chennai",
    "Madurai",
    "Coimbatore",
    "Bangalore",
    "Mumbai",
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    _checkUser();
  }

  Future<void> _checkUser() async {
    String? email = await _storage.read(key: "email");
    String? mobile = await _storage.read(key: "mobile");

    if (email != null && mobile != null) {
      // Already logged in → go Home after splash
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    } else {
      // Animate logo up, then show login
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _logoAlign = Alignment.topCenter);
        Future.delayed(const Duration(seconds: 1), () {
          setState(() => _showLogin = true);
        });
      });
    }
  }

  void _onLogin() async {
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();
    final name = _nameController.text.trim();
    final city = _cityController.text.trim();

    if (email.isEmpty || !email.contains("@")) {
      _showSnack("Enter valid email");
      return;
    }
    if (mobile.length < 10) {
      _showSnack("Enter valid mobile number");
      return;
    }
    if (name.isEmpty) {
      _showSnack("Enter name");
      return;
    }
    if (city.isEmpty) {
      _showSnack("Enter city");
      return;
    }

    // Save securely
    await _storage.write(key: "email", value: email);
    await _storage.write(key: "mobile", value: mobile);
    await _storage.write(key: "name", value: name);
    await _storage.write(key: "city", value: city);

    // Navigate to Home
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kAppGradient),
        child: Stack(
          children: [
            // Logo + Title
            AnimatedAlign(
              alignment: _logoAlign,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Padding(
                padding: EdgeInsets.only(bottom: keyboardHeight / 2), // move up
                child: FadeTransition(
                  opacity: _fade,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.shopping_bag, size: 100, color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        "Own APP",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Smart Delivery at your Doorstep",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Login UI
            if (_showLogin)
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: keyboardHeight),
                  child: FadeTransition(opacity: _fade, child: _buildLoginUI()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginUI() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Email field
            TextField(
              controller: _emailController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                hintText: "Enter your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),

            // Mobile with India flag
            TextField(
              controller: _mobileController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Text("🇮🇳", style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
                hintText: "Enter mobile number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.account_circle_rounded),
                hintText: "Enter your name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),

            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return cities.where(
                  (city) => city.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                );
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                    _cityController.text =
                        controller.text; // link your controller
                    return TextField(
                      controller: controller,
                      textInputAction: TextInputAction.done,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.add_location_alt),
                        hintText: "Type to enter City",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
              onSelected: (String selection) {
                _cityController.text = selection;
              },
            ),
            const SizedBox(height: 15),

            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF5E4FBF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

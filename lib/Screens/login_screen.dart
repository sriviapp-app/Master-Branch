import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:namma_srivi/app_theme.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _storage = const FlutterSecureStorage();
  bool _loading = false;

  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();

  final List<String> cities = [
    "Srivilliputhur",
    "Chennai",
    "Madurai",
    "Coimbatore",
    "Bangalore",
    "Mumbai",
  ];

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

    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 2)); // simulate API delay

    await _storage.write(key: "email", value: email);
    await _storage.write(key: "mobile", value: mobile);
    await _storage.write(key: "name", value: name);
    await _storage.write(key: "city", value: city);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kAppGradient),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.shopping_bag, size: 100, color: Colors.white),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: keyboardHeight),
                    child: _buildLoginCard(),
                  ),
                ),
              ],
            ),
            if (_loading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // Email
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
            const SizedBox(height: 15),

            // Name
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
            ),
            const SizedBox(height: 15),

            // City autocompletes@gs
            // City autocomplete
            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                return cities.where((city) => city.toLowerCase().contains(
                    textEditingValue.text.toLowerCase()));
              },
              onSelected: (value) {
                _cityController.text = value;
                FocusScope.of(context).unfocus(); // <-- dismiss keyboard
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                _cityController.text = controller.text;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.add_location_alt),
                    hintText: "Type to enter City",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

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

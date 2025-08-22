import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namma_srivi/app_theme.dart';
import 'package:namma_srivi/widgets/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'tab2_screen.dart';
import 'tab3_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [HomeTab(), Tab2Screen(), Tab3Screen()];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: gradientAppBar("Own APP"),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(gradient: kAppGradient),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white70,
            ),
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.home),
                    if (_currentIndex == 0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 4,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.list),
                    if (_currentIndex == 1)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 4,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person),
                    if (_currentIndex == 2)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 4,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Home Tab ----------------
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {"icon": Icons.shopping_cart, "label": "Order"},
      {"icon": Icons.support_agent, "label": "Driver Support"},
      {"icon": Icons.help, "label": "Ask Query"},
      {"icon": Icons.history, "label": "Order History"},
      {"icon": Icons.notifications, "label": "Notifications"},
      {"icon": Icons.settings, "label": "Settings"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 x 3 grid
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          final data = buttons[index];
          return OutlinedButton(
            onPressed: () {
              if (data["label"] == "Driver Support") {
                _showDriverSupportDialog(context);
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white24
                    : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientIcon(data["icon"], size: 30, gradient: kAppGradient),
                // ShaderMask(
                //   shaderCallback: (r) => kAppGradient.createShader(r),
                //   child: Icon(data["icon"], size: 30, color: Colors.white),
                // ),
                const SizedBox(height: 8),
                Text(data["label"], textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }

  // Blur dialog for Driver Support
  void _showDriverSupportDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      pageBuilder: (context, _, __) {
        return Stack(
          children: [
            //  Container(
            //   color: Colors.black.withOpacity(0.5), // semi-transparent, no blur
            // ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Contact Driver",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      gradientButton(
                        label: "Call Driver",
                        icon: Icons.phone,
                        onTap: () => {_makePhoneCall("7358882011", context)},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon(
    this.icon, {
    super.key,
    this.size = 24,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          gradient.createShader(Rect.fromLTWH(0, 0, size, size)),
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, size: size, color: Colors.white),
      ),
    );
  }
}

Future<void> _makePhoneCall(String phoneNumber, BuildContext context) async {
  UrlLauncher.launch("tel://<$phoneNumber>");
}

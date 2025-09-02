// dashboard_screen.dart
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:namma_srivi/Dashboard/explore_screen.dart';
import 'package:namma_srivi/app_theme.dart';
import 'package:namma_srivi/widgets/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_screen.dart';
import 'tab2_screen.dart';
import 'LocalNewsScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final List<int> _tabHistory = [];
  final List<Widget> _screens = const [
    HomeTabWithCarousel(),
    Tab2Screen(),
    LocalNewsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabHistory.add(0);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    var cont = context;
    _checkAndShowPopup(cont);

  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _tabHistory.removeLast();
        _currentIndex = _tabHistory.last;
      });
      return false;
    } else {
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Exit App"),
          content: const Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No")),
            TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text("Yes")),
          ],
        ),
      );
      return result ?? false;
    }
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
        _tabHistory.add(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppTheme().gradientAppBar(context, "Own APP"),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(gradient: AppTheme.lightGradient),
          child: SafeArea(
            top: false,
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              onTap: _onTabTapped,
              items: [
                _navItem(Icons.home, "Home", 0),
                _navItem(Icons.list, "Tea shop orders", 1),
                _navItem(Icons.newspaper, "News", 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          if (_currentIndex == index)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 20,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(2)),
            ),
        ],
      ),
      label: label,
    );
  }

}

Future<void> _checkAndShowPopup(BuildContext buildContext) async {
  //final prefs = await SharedPreferences.getInstance();
  final prefs = const FlutterSecureStorage();
  final String? loginResponse = await prefs.read(key: "loginResponse");
 // final String? loginResponse = prefs.getString("loginResponse");

  if (loginResponse != null) {
    final data = jsonDecode(loginResponse);
    final content = data["content"];

    if (content["showPopup"] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWelcomeBottomSheet(buildContext, content["popupContent"]);
      });

      // update showPopup flag and save back
      content["showPopup"] = false;
      data["content"] = content;
      prefs.write(key: "loginResponse", value: jsonEncode(data));
    }
  }
}


void _showWelcomeBottomSheet(BuildContext context, Map popupContent) {
  showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Show Image or Text based on popupContent
              if (popupContent["showImage"] == true)
                Image.network(popupContent["imageURL"], height: 150),
              if (popupContent["showText"] == true)
                Text(
                  popupContent["textContent"],
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.orangeAccent,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text("Got it"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ---------------------- Home Tab + Carousel -----------------------
class HomeTabWithCarousel extends StatelessWidget {
  const HomeTabWithCarousel({super.key});

  final List<String> carouselImages = const [
    "images/Temple_Nearby.png",
    "images/Order Now.png",
    "images/Need help.png",
  ];

  @override
  Widget build(BuildContext context) {
    List<Function()> callbacks = [
          () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ExploreSriviScreen())),
          () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const OrderScreen())),
          () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const OrderScreen())),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          PremiumCarousel(images: carouselImages, onTapCallbacks: callbacks),
          const SizedBox(height: 16),
          const HomeTab(),
        ],
      ),
    );
  }
}

// ---------------------- Premium Carousel -----------------------
class PremiumCarousel extends StatefulWidget {
  final List<String> images;
  final List<Function()> onTapCallbacks;

  const PremiumCarousel(
      {super.key, required this.images, required this.onTapCallbacks});

  @override
  State<PremiumCarousel> createState() => _PremiumCarouselState();
}

class _PremiumCarouselState extends State<PremiumCarousel> {
  late PageController _controller;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1);

    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_controller.hasClients) {
        _controller.animateToPage(_currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: widget.onTapCallbacks[index],
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(widget.images[index],
                            fit: BoxFit.cover, width: double.infinity),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 75,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppTheme.lightGradient,
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 14 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _currentPage == index
                    ? Colors.deepPurple
                    : Colors.grey[400],
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ---------------------- Original HomeTab -----------------------
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {"icon": Icons.shopping_cart, "label": "Order"},
      {"icon": Icons.support_agent, "label": "Driver Support"},
      {"icon": Icons.help, "label": "Ask Query"},
      {"icon": Icons.settings, "label": "Settings"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          final data = buttons[index];
          return OutlinedButton(
            onPressed: () {
              if (data["label"] == "Order") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderScreen()),
                );
              }
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
                GradientIcon(data["icon"],
                    size: 30, gradient: AppTheme.lightGradient),
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
                        context: context,
                        label: "Call Driver",
                        icon: Icons.phone,
                        onTap: () => {_makePhoneCall("7358882011")},
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

  Widget gradientButton({
    required BuildContext context,
    required String label,
    IconData? icon,
    required VoidCallback onTap,
    EdgeInsetsGeometry padding =
    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    double radius = 12,
  }) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppTheme.buttonGradient(isDarkMode: isDark),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppTheme.lightAccent),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.lightAccent,
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
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon(this.icon,
      {super.key, this.size = 24, required this.gradient});

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

Future<void> _makePhoneCall(String phoneNumber) async {
  UrlLauncher.launch("tel://$phoneNumber");
}

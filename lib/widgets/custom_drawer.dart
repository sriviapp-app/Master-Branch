import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app_theme.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Map<String, String?>? _userDetails;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    const storage = FlutterSecureStorage();
    final name = await storage.read(key: "name");
    final mobile = await storage.read(key: "mobile");
    final email = await storage.read(key: "email");
    final city = await storage.read(key: "city");
    setState(() {
      _userDetails = {
        "name": name,
        "mobile": mobile,
        "email": email,
        "city": city,
      };
      _loading = false;
    });
  }

  Future<void> _confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                const storage = FlutterSecureStorage();
                await storage.deleteAll(); // clear storage

                Navigator.of(ctx).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/', // back to splash/login
                      (route) => false,
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
            decoration: BoxDecoration(
              gradient: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 28, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userDetails?["name"] ?? "User",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if ((_userDetails?["mobile"] ?? "").isNotEmpty)
                        Text(
                          _userDetails!["mobile"]!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                      if ((_userDetails?["email"] ?? "").isNotEmpty)
                        Text(
                          _userDetails!["email"]!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                      if ((_userDetails?["city"] ?? "").isNotEmpty)
                        Text(
                          _userDetails!["city"]!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                _DrawerItem(title: "Discounts", icon: Icons.local_offer),
                _DrawerItem(title: "Gadgets", icon: Icons.devices),
                _DrawerItem(title: "TV, audio", icon: Icons.tv),
                _DrawerItem(title: "Laptops & Notebooks", icon: Icons.laptop),
                _DrawerItem(title: "Smart home", icon: Icons.home),
                _DrawerItem(title: "Photo, Video", icon: Icons.photo_camera),
                Divider(),
                _DrawerItem(title: "Delivery", icon: Icons.delivery_dining),
                _DrawerItem(title: "Contacts", icon: Icons.contacts),
              ],
            ),
          ),

          // Sign out button
          Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, bottom + 8),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Sign out",
                  style: TextStyle(color: Colors.red)),
              onTap: () => _confirmLogout(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const _DrawerItem({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
          color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pop(context),
    );
  }
}

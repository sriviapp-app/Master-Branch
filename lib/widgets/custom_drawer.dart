import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../app_theme.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<Map<String, String?>> _getUserDetails() async {
    const storage = FlutterSecureStorage();
    final name = await storage.read(key: "name");
    final phone = await storage.read(key: "phone");
    final email = await storage.read(key: "email");
    final city = await storage.read(key: "city");
    return {"name": name, "phone": phone, "email": email , "city":city};
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
              onPressed: () => Navigator.of(ctx).pop(), // close dialog
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                const storage = FlutterSecureStorage();
                await storage.deleteAll(); // clear storage

                Navigator.of(ctx).pop(); // close dialog
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/', // navigate back to splash/login
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
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: Column(
          children: [
            // Gradient header
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
              decoration: const BoxDecoration(gradient: kAppGradient),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 28, color: kPrimaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FutureBuilder<Map<String, String?>>(
                      future: _getUserDetails(),
                      builder: (context, snapshot) {
                        final name = snapshot.data?["name"] ?? "User";
                        final phone = snapshot.data?["phone"] ?? "";
                        final email = snapshot.data?["email"] ?? ".....@gmail.com";
                        final city = snapshot.data?["city"] ?? "City";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (phone.isNotEmpty)
                              Text(
                                phone,
                                style: const TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            if (email.isNotEmpty)
                              Text(
                                email,
                                style: const TextStyle(color: Colors.white70, fontSize: 18),
                              ),
                            if (city.isNotEmpty)
                              Text(
                                city,
                                style: const TextStyle(color: Colors.white70, fontSize: 18),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),

            // Menu
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: const [
                  _Item(title: "Discounts", icon: Icons.local_offer),
                  _Item(title: "Gadgets", icon: Icons.devices),
                  _Item(title: "TV, audio", icon: Icons.tv),
                  _Item(title: "Laptops & Notebooks", icon: Icons.laptop),
                  _Item(title: "Smart home", icon: Icons.home),
                  _Item(title: "Photo, Video", icon: Icons.photo_camera),
                  Divider(),
                  _Item(title: "Delivery", icon: Icons.delivery_dining),
                  _Item(title: "Contacts", icon: Icons.contacts),
                ],
              ),
            ),

            // Bottom action
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, bottom + 8),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Sign out", style: TextStyle(color: Colors.red)),
                onTap: () => _confirmLogout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final IconData icon;

  const _Item({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pop(context),
    );
  }
}

import 'package:flutter/material.dart';

import '../app_theme.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
            // Gradient header (edge-to-edge)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
              decoration: const BoxDecoration(gradient: kAppGradient),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 28, color: kPrimaryColor),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "City: Your City",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
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
              child: const ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Sign out", style: TextStyle(color: Colors.red)),
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

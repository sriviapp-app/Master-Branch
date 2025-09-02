import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namma_srivi/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreSriviScreen extends StatelessWidget {
  const ExploreSriviScreen({super.key});

  // Open location in Google Maps
  Future<void> _openMap(String query) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$query",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Explore Srivilliputhur"),
          backgroundColor: AppTheme.lightPrimary, // your gradient top color
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildExpandableCard(
              title: "Nearby Transport",
              subtitle: "Explore nearby Transport",
              icon: Icons.directions_bus,
              color: Colors.blue,
              items: [
                "Srivilliputhur Old Bus Stand",
                "Srivilliputhur New Bus Stand",
                "Srivilliputhur Railway Station",
                "Rajapalayam Railway Station",
                "Sivakasi Bus Stand",
                "Madurai Airport",
                "Madurai Junction",
                "Madurai Railway Station",
                "Mattuthavani Omni Bus Stand",
              ],
            ),
            const SizedBox(height: 12),
            _buildExpandableCard(
              title: "Nearby Medical Centre",
              subtitle: "Explore nearby Medical Centre",
              icon: Icons.local_hospital,
              color: Colors.red,
              items: [
                "Government Hospital, Srivilliputhur",
                "Thavamani Hospital",
                "Rajesh Hospital",
                "Sudha Hospital",
                "Thavamani Nursing Home",
                "Subham Hospital",
                "Sri Venkateswara Hospital",
                "Siva Hospital"
              ],
            ),
            const SizedBox(height: 12),
            _buildExpandableCard(
              title: "Nearby Hotels",
              subtitle: "Explore nearby Hotels",
              icon: Icons.hotel,
              color: Colors.brown,
              items: [
                "Selvam Tea Stall",
                "Hari Tea Stall",
                "Eswaran Mess Tea Corner",
                "Amsavalli Bhavan",
                "Arya Bhavan",
                "Sri Krishna Bhavan",
                "Sree Saravana Bhavan",
                "Hotel Meenakshi Bhavan",
                "New Madurai Hotel",
                "Ponram Hotel",
                "Velu Briyani Kadai",
                "Hotel Gowri Shankar",
                "Amul Ice Cream Parlour",
                "Ibaco Ice Creams",
                "Aavin Parlour"

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        children: items
            .map(
              (place) => ListTile(
                title: Text(place),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.green,
                ),
                onTap: () => _openMap(place),
              ),
            )
            .toList(),
      ),
    );
  }
}

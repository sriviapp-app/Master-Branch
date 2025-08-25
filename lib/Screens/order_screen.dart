import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _PalkovaOrderScreenState();
}

class _PalkovaOrderScreenState extends State<OrderScreen> {
  final String driverPhone = "7358882011";

  final List<Map<String, String>> palkovaList = const [
    {"name": "Plain Palkova"},
    {"name": "Kesar Palkova"},
    {"name": "Dry Fruit Palkova"},
    {"name": "Chocolate Palkova"},
  ];

  @override
  void initState() {
    super.initState();
    // Any init configuration
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
return SafeArea(child: Scaffold(
  appBar: AppBar(
    title: const Text("Palkova List"),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)], // Palkova-ish
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
  ),
  body: ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: palkovaList.length,
    itemBuilder: (context, index) {
      final item = palkovaList[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item["name"]!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Quantity: 1/4 kg"),
              const SizedBox(height: 4),
              const Text("Price: ₹60"),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall(driverPhone),
                  icon: const Icon(Icons.phone),
                  label: const Text("Book – Call"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
) );

  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}

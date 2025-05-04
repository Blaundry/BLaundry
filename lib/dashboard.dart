import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/regularwash.dart';
import 'package:blaundry_registlogin/shoewash.dart';
import 'package:blaundry_registlogin/washiron.dart';
import 'package:blaundry_registlogin/myorder.dart';
import 'package:blaundry_registlogin/button_navbar_user.dart';
import 'package:blaundry_registlogin/profile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  String username = "Khidir Julian";

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyOrderPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF05588A),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Home',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Text(
                    username[0],
                    style: const TextStyle(
                      color: Color.fromARGB(255, 33, 149, 243),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            // Blue Background (matches app bar)
            Container(
              color: const Color(0xFF05588A),
            ),

            // Main Scrollable Content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header Image with Dark Overlay
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/laundry_bg.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 33, 149, 243)
                              .withOpacity(0.8), // Atur opasitas di sini
                        ),
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello, $username!',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Have you checked today's laundry?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // White Container for Services (rounded top)
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Column(
                      children: [
                        // Services Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildServiceButton(
                                Icons.local_laundry_service,
                                'Regular Wash',
                                Colors.purple,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegularWashPage()),
                                ),
                              ),
                              _buildServiceButton(
                                Icons.iron,
                                'Wash+Iron',
                                Colors.orange,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WashIronPage()),
                                ),
                              ),
                              _buildServiceButton(
                                Icons.directions_run,
                                'Shoe Wash',
                                Colors.blue,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ShoeWashPage()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Blue Background Content Below White Container
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF05588A),Color(0xFF0999F0), ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Estimated Time
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF29A3FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  "Estimated time remaining:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "1 days 15 hours",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Large Scrollable Gap
                        const SizedBox(height: 100),

                        // Today's Offer
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Today's Offer",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Special offers will appear here",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Wave Animation at Bottom
          ],
        ),
        bottomNavigationBar: BottomNavBaruser(
          selectedIndex: _selectedIndex.clamp(0, 1),
          onTap: _onNavBarTap,
        ),
      ),
    );
  }

  Widget _buildServiceButton(
      IconData icon, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/regularwash.dart';
import 'package:blaundry_registlogin/shoewash.dart';
import 'package:blaundry_registlogin/washiron.dart';
import 'package:blaundry_registlogin/login_customer.dart';
import 'package:blaundry_registlogin/bottom_navbar_admin.dart'; // Import BottomNavBar
import 'package:blaundry_registlogin/Customer_Data.dart'; // Import CustomerDataPage

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  _DashboardAdminPageState createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _selectedIndex = 0;

  // Fungsi untuk navigasi berdasarkan indeks navbar
  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi ke halaman sesuai indeks
    switch (index) {
      case 0:
        // Tetap di halaman DashboardAdminPage
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const CustomerDataPage(), // Navigate to CustomerDataPage
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Scaffold(
                body: Center(child: Text("Blank Page"))), // Blank Page
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Admin Dashboard',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => _showLogoutConfirmation(context),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Welcome, Admin!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Manage your laundry services here.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 50),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildServiceButton(
                                Icons.local_laundry_service_rounded,
                                'Regular Wash',
                                Colors.pinkAccent,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegularWashPage(),
                                    ),
                                  );
                                },
                              ),
                              _buildServiceButton(
                                Icons.directions_run,
                                'Shoe Wash',
                                Colors.blue,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ShoeWashPage(),
                                    ),
                                  );
                                },
                              ),
                              _buildServiceButton(
                                Icons.iron,
                                'Wash + Iron',
                                Colors.blue,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WashIronPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/logosimple4.png',
              width: 100,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("Do you really want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginCustomerPage()),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildServiceButton(
      IconData icon, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

import 'package:blaundry_registlogin/login_customer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:blaundry_registlogin/regularwash.dart';
import 'package:blaundry_registlogin/shoewash.dart';
import 'package:blaundry_registlogin/washiron.dart';
import 'package:blaundry_registlogin/myorder.dart';
import 'package:blaundry_registlogin/button_navbar_user.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Menonaktifkan tombol back
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Menonaktifkan tombol back
          backgroundColor: Colors.blue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('Home',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 20),
                ],
              ),
              GestureDetector(
                onTap: () => _showLogoutConfirmation(context),
                child: const Text('Logout',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
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
                    'Hello, User!',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Have you checked today’s laundry?',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 50),
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: SingleChildScrollView(
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
                                                const RegularWashPage()),
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
                                                const ShoeWashPage()),
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
                                                const WashIronPage()),
                                      );
                                    },
                                  ),
                                  _buildServiceButton(
                                    Icons.shopping_basket,
                                    'My Order',
                                    Colors.pinkAccent,
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyOrderPage()),
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
            Positioned(
              bottom: -MediaQuery.of(context).size.height * 0.005,
              left: 0,
              right: 0,
              child: Lottie.asset(
                'assets/wave.json',
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.125,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBaruser(
            selectedIndex: _selectedIndex, onTap: _onNavBarTap),
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
                    MaterialPageRoute(
                        builder: (context) => const LoginCustomerPage()));
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
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(text,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

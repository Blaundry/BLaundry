import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/regularwash.dart';
import 'package:blaundry_registlogin/shoewash.dart';
import 'package:blaundry_registlogin/washiron.dart';
import 'package:blaundry_registlogin/myorder.dart';
import 'package:blaundry_registlogin/button_navbar_user.dart';
import 'package:blaundry_registlogin/profile.dart';
import 'package:blaundry_registlogin/chatBot.dart'; 

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  String username = "Khidir Julian";
  final PageController _pageController = PageController(viewportFraction: 0.8);

  final List<Map<String, dynamic>> offers = [
    {
      'title': 'Weekend Special',
      'description': '20% OFF on all services every Saturday',
      'icon': Icons.weekend,
      'color': Colors.orange,
      'validUntil': 'Valid every weekend'
    },
    {
      'title': 'First Time User',
      'description': '15% OFF on your first order',
      'icon': Icons.star,
      'color': Colors.blue,
      'validUntil': 'New customers only'
    },
    {
      'title': 'Bulk Discount',
      'description': '10kg+ laundry gets 10% OFF',
      'icon': Icons.local_laundry_service,
      'color': Colors.green,
      'validUntil': 'Valid until Dec 2023'
    },
    {
      'title': 'Express Service',
      'description': 'Free upgrade to express for orders >50kg',
      'icon': Icons.flash_on,
      'color': Colors.red,
      'validUntil': 'Limited time offer'
    },
    {
      'title': 'Early Bird',
      'description': '10% OFF for orders placed before 10AM',
      'icon': Icons.wb_sunny,
      'color': Colors.amber,
      'validUntil': 'Daily offer'
    },
    {
      'title': 'Loyalty Reward',
      'description': 'Free service after 10 orders',
      'icon': Icons.loyalty,
      'color': Colors.pink,
      'validUntil': 'For all customers'
    },
  ];

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
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
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
            Container(color: const Color(0xFF05588A)),
            SingleChildScrollView(
              child: Column(
                children: [
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
                        color: const Color(0xFF2196F3).withOpacity(0.8),
                      ),
                      Container(
                        height: 200,
                        color: Colors.black.withOpacity(0.4),
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
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
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
                                  MaterialPageRoute(builder: (context) => const RegularWashPage()),
                                ),
                              ),
                              _buildServiceButton(
                                Icons.iron,
                                'Wash+Iron',
                                Colors.orange,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WashIronPage()),
                                ),
                              ),
                              _buildServiceButton(
                                Icons.directions_run,
                                'Shoe Wash',
                                Colors.blue,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ShoeWashPage()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF05588A), Color(0xFF0999F0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
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
                              SizedBox(
                                height: 180,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: offers.length,
                                  itemBuilder: (context, index) {
                                    return _buildOfferCard(offers[index]);
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
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
          ],
        ),
        bottomNavigationBar: BottomNavBaruser(
          selectedIndex: _selectedIndex.clamp(0, 1),
          onTap: _onNavBarTap,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatBotPage()),
            );
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.chat),
        ),
      ),
    );
  }

  Widget _buildServiceButton(IconData icon, String text, Color color, VoidCallback onTap) {
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [offer['color'].withOpacity(0.7), offer['color']],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(offer['icon'], size: 30, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  offer['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              offer['description'],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              offer['validUntil'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

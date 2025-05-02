import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/myorder.dart';
import 'package:blaundry_registlogin/profile.dart';

class BottomNavBaruser extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBaruser({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyOrderPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          } else {
            onTap(index);
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 33, 149, 243),
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 4),
              child: Icon(Icons.home, size: 24),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 4),
              child: Icon(Icons.shopping_basket, size: 24),
            ),
            label: "My Order",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 4),
              child: Icon(Icons.person, size: 24),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

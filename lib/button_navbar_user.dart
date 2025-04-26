import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/myorder.dart';
import 'package:blaundry_registlogin/profile.dart'; // Import ProfilePage

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
    return BottomNavigationBar(
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
            MaterialPageRoute(
                builder: (context) =>
                    const ProfilePage()), // Navigate to ProfilePage
          );
        } else {
          onTap(index);
        }
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket), // Ikon untuk My Order
          label: "My Order",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // Ikon untuk My Account
          label: "My Account",
        ),
      ],
    );
  }
}

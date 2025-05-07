import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/pages/Customer_Data.dart';
import 'package:blaundry_registlogin/pages/Customer_order.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
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
            MaterialPageRoute(builder: (context) => const CustomerDataPage()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const CustomerOrderPage(), // Navigate to CustomerOrderPage
            ),
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
          icon: Icon(Icons.people), // Ikon untuk Customer Data
          label: "Customer Data",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), // Ikon untuk Customer Order
          label: "Customer Order",
        ),
      ],
    );
  }
}

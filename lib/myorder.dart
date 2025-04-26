import 'package:flutter/material.dart';
import 'payment.dart';
import 'dashboard.dart'; // Import the dashboard page

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to DashboardPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Regular Wash - 3 Items'),
            subtitle: const Text('Status: In Process'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentPage()),
              );
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Shoe Wash - 1 Item'),
            subtitle: Text('Status: Done'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/payment.dart';
import 'package:blaundry_registlogin/dashboard.dart';
import 'package:blaundry_registlogin/profile.dart';
import 'package:blaundry_registlogin/button_navbar_user.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 149, 243),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Active Orders',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),
            const SizedBox(height: 12),
            _buildOrderCard(
              context,
              service: 'Regular Wash',
              items: 3,
              status: 'In Process',
              statusColor: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentPage()),
              ),
            ),
            const SizedBox(height: 24),
            Text('Order History',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),
            const SizedBox(height: 12),
            _buildOrderCard(
              context,
              service: 'Shoe Wash',
              items: 1,
              status: 'Completed',
              statusColor: Colors.green,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBaruser(
        selectedIndex: 1, // My Order is selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String service,
    required int items,
    required String status,
    required Color statusColor,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_laundry_service,
                    size: 24, color: Color.fromARGB(255, 33, 149, 243)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xFF333333),
                        )),
                    const SizedBox(height: 4),
                    Text('$items ${items > 1 ? 'items' : 'item'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        )),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(height: 8),
                    const Icon(Icons.chevron_right,
                        size: 20, color: Colors.grey),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/pages/payment.dart';
import 'package:blaundry_registlogin/pages/dashboard.dart';
import 'package:blaundry_registlogin/pages/profile.dart';
import 'package:blaundry_registlogin/widgets/button_navbar_user.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final username = user?.displayName ?? "Guest"; // Fallback to "Guest" if no displayName is set

    if (userId == null) {
      return const Center(child: Text("User is not logged in"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: const Color(0xFF05588A),
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('userId', isEqualTo: userId)
                    .where('status', isNotEqualTo: 'Finished')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Error loading orders: ${snapshot.error}");
                    return const Center(child: Text('Error loading orders'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final activeOrders = snapshot.data!.docs;

                  if (activeOrders.isEmpty) {
                    return const Center(child: Text('No active orders'));
                  }

                  return ListView.builder(
                    itemCount: activeOrders.length,
                    itemBuilder: (context, index) {
                      final doc = activeOrders[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final orderId = doc.id;

                      return _buildOrderCard(
                        context,
                        orderId: activeOrders[index].id, // this is your actual document ID (orderId)
                        service: data['serviceType'] ?? 'Laundry',
                        items: data['quantity'] ?? 0,
                        status: data['status'] ?? 'Unknown',
                        statusColor: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(orderId: orderId), // passing the doc ID
                          ),
                        ),
                      );
                    }
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text('Order History',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 16,
                    )),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('userId', isEqualTo: userId) // Filter berdasarkan userId
                    .where('status', isEqualTo: 'Finished')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Error loading orders: ${snapshot.error}");
                    return const Center(child: Text('Error loading history'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final historyOrders = snapshot.data!.docs;

                  if (historyOrders.isEmpty) {
                    return const Center(child: Text('No completed orders yet'));
                  }

                  return ListView.builder(
                    itemCount: historyOrders.length,
                    itemBuilder: (context, index) {
                      final data =
                          historyOrders[index].data() as Map<String, dynamic>;

                      return _buildOrderCard(
                        context,
                        orderId: historyOrders[index].id,
                        service: data['serviceType'] ?? 'Laundry',
                        items: data['quantity'] ?? 0,
                        status: data['status'] ?? 'Completed',
                        statusColor: Colors.green,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBaruser(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardPage(), // No username passed here
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String orderId,
    required String service,
    required int items,
    required String status,
    VoidCallback? onTap,
    required MaterialColor statusColor,
  }) {
    // Tentukan warna dan ikon berdasarkan status
    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (status) {
      case 'Pending to Process':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        statusLabel = 'Pending';
        break;
      case 'Processed':
        statusColor = Colors.blue;
        statusIcon = Icons.autorenew;
        statusLabel = 'In Process';
        break;
      case 'Finished':
        statusColor = Colors.purple;
        statusIcon = Icons.check_circle_outline;
        statusLabel = 'Finished';
        break;
      case 'Completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusLabel = 'Completed';
        break;
      case 'Payment':
        statusColor = Colors.red;
        statusIcon = Icons.payment;
        statusLabel = 'Payment Required';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusLabel = 'Unknown';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // If the status is "Payment", navigate to PaymentPage
          if (status == 'Payment') {
            Navigator.push(
              context,
              MaterialPageRoute(
                 builder: (context) => PaymentPage(orderId: orderId),
              ),
            );
          } else {
            // You can add other navigation logic here for other statuses if needed
            onTap?.call();  // If onTap is provided, call it (useful for other statuses)
          }
        },
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
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            )),
                      ],
                    ),
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
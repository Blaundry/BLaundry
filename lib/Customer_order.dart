import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/bottom_navbar_admin.dart';
import 'package:blaundry_registlogin/dashboard_Admin.dart';

class CustomerOrderPage extends StatefulWidget {
  const CustomerOrderPage({super.key});

  @override
  _CustomerOrderPageState createState() => _CustomerOrderPageState();
}

class _CustomerOrderPageState extends State<CustomerOrderPage> {
  int _selectedIndex = 2;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardAdminPage()),
        );
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/customer_data');
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Customers Order",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _orderStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading orders'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!.docs;

                if (orders.isEmpty) {
                  return const Center(child: Text('No orders found'));
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final data = orders[index].data() as Map<String, dynamic>;
                    final docId = orders[index].id;

                    return orderCard(
                      context,
                      orderId: docId,
                      service: data['serviceType'] ?? 'Unknown',
                      price: data['totalCost']?.toString() ?? 'Rp.0',
                      status: data['status'] ?? 'Unknown',
                    );
                  },
                );
              },
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

  Widget orderCard(
    BuildContext context, {
    required String orderId,
    required String service,
    required String price,
    required String status,
  }) {
    List<String> statusOptions = [
      'Pending to Process',
      'Processed',
      'Finished',
    ];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text("ID: $orderId"),
            Text("Price: $price"),
            const SizedBox(height: 8),
            const Text("Status:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: statusOptions.contains(status) ? status : null,
              decoration: InputDecoration(
                labelText: 'Change Order Status',
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(fontSize: 14, color: Colors.black),
              dropdownColor: Colors.white,
              items: statusOptions.map((String value) {
                Color textColor;
                switch (value) {
                  case 'Finished':
                    textColor = Colors.green;
                    break;
                  case 'Processed':
                    textColor = Colors.blue;
                    break;
                  case 'Pending to Process':
                    textColor = Colors.grey;
                    break;
                  default:
                    textColor = Colors.black;
                }

                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: textColor, size: 18),
                      const SizedBox(width: 8),
                      Text(value, style: TextStyle(color: textColor)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newStatus) async {
                if (newStatus != null && newStatus != status) {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Update Status'),
                      content: Text('Change status to "$newStatus"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderId)
                        .update({'status': newStatus});

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Status updated to $newStatus')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

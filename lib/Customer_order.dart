import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/bottom_navbar_admin.dart'; // Import BottomNavBar
import 'package:blaundry_registlogin/dashboard_Admin.dart';

class CustomerOrderPage extends StatefulWidget {
  const CustomerOrderPage({super.key});

  @override
  _CustomerOrderPageState createState() => _CustomerOrderPageState();
}

class _CustomerOrderPageState extends State<CustomerOrderPage> {
  final List<Map<String, dynamic>> orders = [
    {
      "id": "001-000-000",
      "service": "Wash + Iron",
      "price": "Rp.XX.XXX.XX-",
      "status": "Finished",
      "buttonText": "Finished",
      "buttonColor": Colors.blue,
    },
    {
      "id": "002-000-000",
      "service": "Wash + Iron",
      "price": "Rp.XX.XXX.XX-",
      "status": "Processed",
      "buttonText": "Process",
      "buttonColor": Colors.blue,
    },
    {
      "id": "003-000-000",
      "service": "Wash + Iron",
      "price": "Rp.XX.XXX.XX-",
      "status": "Pending to Process",
      "buttonText": "Accept",
      "buttonColor": Colors.grey,
    },
    {
      "id": "004-000-000",
      "service": "Regular Wash",
      "price": "Rp.XX.XXX.XX-",
      "status": "Pending to Process",
      "buttonText": "Accept",
      "buttonColor": Colors.grey,
    },
  ];

  int _selectedIndex = 2; // Set default index to "Customer Order"

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi ke halaman sesuai indeks
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardAdminPage()),
        );
        break;
      case 1:
        Navigator.pushReplacementNamed(
            context, '/customer_data'); // Customer Data
        break;
      case 2:
        // Tetap di halaman CustomerOrderPage
        break;
    }
  }

  void updateOrderStatus(int index) {
    setState(() {
      if (orders[index]["buttonText"] == "Accept") {
        orders[index]["buttonText"] = "Process";
        orders[index]["buttonColor"] = Colors.blue;
        orders[index]["status"] = "Processed";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pesanan akan segera diproses")),
        );
      } else if (orders[index]["buttonText"] == "Process") {
        orders[index]["buttonText"] = "Finished";
        orders[index]["status"] = "Finished";
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Pesanan dalam proses")));
      } else if (orders[index]["buttonText"] == "Finished") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Pesanan telah selesai")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.blue.shade800, // Warna AppBar sesuai dengan gradient atas
        elevation: 0, // Hilangkan bayangan AppBar
        toolbarHeight: 80, // Tambahkan tinggi AppBar
        title: const Padding(
          padding: EdgeInsets.only(
              top: 10), // Tambahkan padding untuk menurunkan judul
          child: Text(
            "Customers Order",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true, // Pusatkan judul
      ),
      body: Column(
        children: [
          // Header Gradient
          Container(
            padding: const EdgeInsets.only(
                top: 10,
                bottom: 20,
                left: 16,
                right: 16), // Naikkan posisi search bar
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                TextField(
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
              ],
            ),
          ),
          // Order List
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return orderCard(
                  context,
                  orders[index]["id"],
                  orders[index]["service"],
                  orders[index]["price"],
                  orders[index]["status"],
                  orders[index]["buttonText"],
                  orders[index]["buttonColor"],
                  index,
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
    BuildContext context,
    String orderId,
    String service,
    String price,
    String status,
    String buttonText,
    Color buttonColor,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          service,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(orderId),
            Text(price),
            Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => updateOrderStatus(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
          ),
          child: Text(buttonText),
        ),
      ),
    );
  }
}

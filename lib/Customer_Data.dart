import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/bottom_navbar_admin.dart';
import 'package:blaundry_registlogin/dashboard_admin.dart';

class CustomerDataPage extends StatefulWidget {
  const CustomerDataPage({super.key});

  @override
  _CustomerDataPageState createState() => _CustomerDataPageState();
}

class _CustomerDataPageState extends State<CustomerDataPage> {
  final List<Map<String, String>> _customers = [
    {"name": "John Doe", "address": "New York", "phone": "12345"},
    {"name": "Jane Smith", "address": "Los Angeles", "phone": "67890"},
    {"name": "Michael Brown", "address": "Chicago", "phone": "54321"},
    {"name": "Emily Davis", "address": "Houston", "phone": "98765"},
    {"name": "William Wilson", "address": "Miami", "phone": "45678"},
  ];

  int _selectedIndex = 1;

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
        // Stay in current page
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text("Blank Page")),
            ),
          ),
        );
        break;
    }
  }

  void _showEditCustomerDialog(int index) {
    final nameController =
        TextEditingController(text: _customers[index]["name"]);
    final addressController =
        TextEditingController(text: _customers[index]["address"]);
    final phoneController =
        TextEditingController(text: _customers[index]["phone"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Customer",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _customers[index]["name"] = nameController.text;
                      _customers[index]["address"] = addressController.text;
                      _customers[index]["phone"] = phoneController.text;
                    });
                    Navigator.pop(context);
                    _showSuccessMessage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Customer data updated successfully!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF05588A), // Warna AppBar sesuai dengan gradient atas
        elevation: 0, // Hilangkan bayangan AppBar
        toolbarHeight: 80, // Tambahkan tinggi AppBar
        title: const Padding(
          padding: EdgeInsets.only(
              top: 10), // Tambahkan padding untuk menurunkan judul
          child: Text(
            "Customers Data",
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
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 10, bottom: 20, left: 16, right: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF05588A), Color(0xFF0999F0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Tambahkan jarak dari AppBar
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Customer List
          Expanded(
            child: ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      customer["name"] ?? "-",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(customer["address"] ?? "-"),
                    trailing: ElevatedButton(
                      onPressed: () => _showEditCustomerDialog(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Edit"),
                    ),
                  ),
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
}

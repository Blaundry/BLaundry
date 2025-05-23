import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/widgets/bottom_navbar_admin.dart';
import 'package:blaundry_registlogin/pages/dashboard_admin.dart';

class CustomerDataPage extends StatefulWidget {
  const CustomerDataPage({super.key});

  @override
  _CustomerDataPageState createState() => _CustomerDataPageState();
}

class _CustomerDataPageState extends State<CustomerDataPage> {
  int _selectedIndex = 1;
  String _searchQuery = "";

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

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> customersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Customers Data",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white
            ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search by name and email ...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: customersStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No customers found'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading customers'));
                }

                final filteredCustomers = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  final email = (data['email'] ?? '').toString().toLowerCase();
                  final role = data['role'] ?? '';
                  return role == 'user' &&
                      (_searchQuery.isEmpty ||
                      name.contains(_searchQuery) ||
                      email.contains(_searchQuery));
                }).toList();


                if (filteredCustomers.isEmpty) {
                  return const Center(child: Text('No matching customers found'));
                }

                return ListView.builder(
                  itemCount: filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final data = filteredCustomers[index].data() as Map<String, dynamic>;
                    final docId = filteredCustomers[index].id;

                    return customerCard(
                      context,
                      docId: docId,
                      name: data['name'] ?? 'Unknown',
                      email: data['email'] ?? 'Unknown',
                      address: data['address'] ?? 'Unknown',
                      phone: data['phone'] ?? 'Unknown',
                      password: data['password'] ?? '',
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

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Customer data updated successfully!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showEditCustomerDialog(
    String docId,
    String name,
    String email,
    String address,
    String phone,
    String password,
  ) {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final addressController = TextEditingController(text: address);
    final phoneController = TextEditingController(text: phone);
    final passwordController = TextEditingController(text: password);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Customer"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  readOnly: true,
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
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  readOnly: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').doc(docId).update({
                  'name': nameController.text,
                  'email': emailController.text,
                  'address': addressController.text,
                  'phone': phoneController.text,
                  'password': passwordController.text,
                });

                Navigator.pop(context);
                _showSuccessMessage();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget customerCard(
    BuildContext context, {
    required String docId,
    required String name,
    required String email,
    required String address,
    required String phone,
    required String password,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text("Email: $email"),
            Text("Address: $address"),
            Text("Phone: $phone"),
            Text("Password: $password"),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showEditCustomerDialog(
                docId,
                name,
                email,
                address,
                phone,
                password,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Edit Info"),
            ),
          ],
        ),
      ),
    );
  }
}

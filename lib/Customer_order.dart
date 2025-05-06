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
  String _searchQuery = '';
  String _sortBy = 'serviceType';
  bool _isAscending = true;

  Map<String, Map<String, dynamic>> _userMap = {};

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final userMap = <String, Map<String, dynamic>>{};
    for (var doc in snapshot.docs) {
      userMap[doc.id] = doc.data() as Map<String, dynamic>;
    }
    setState(() {
      _userMap = userMap;
    });
  }

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
    final Stream<QuerySnapshot> _orderStream =
        FirebaseFirestore.instance.collection('orders').snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
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
              onChanged: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search by Customer Name",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _sortBy,
                onChanged: (newSortBy) {
                  setState(() {
                    _sortBy = newSortBy!;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'serviceType',
                    child: Text("Sort by Service Type"),
                  ),
                  DropdownMenuItem(
                    value: 'status',
                    child: Text("Sort by Status"),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                ),
                onPressed: () {
                  setState(() {
                    _isAscending = !_isAscending;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _orderStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading orders'));
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    _userMap.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!.docs;

                final filteredOrders = orders.where((order) {
                  final orderData = order.data() as Map<String, dynamic>;
                  final userId = orderData['userId'];
                  final userData = _userMap[userId];

                  if (_searchQuery.isEmpty) return true;
                  if (userData == null) return false;

                  final userName = userData['name']?.toLowerCase() ?? '';
                  return userName.contains(_searchQuery);
                }).toList();

                filteredOrders.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;

                  if (_sortBy == 'serviceType') {
                    final aService = (aData['serviceType'] ?? '') as String;
                    final bService = (bData['serviceType'] ?? '') as String;
                    return _isAscending
                        ? aService.compareTo(bService)
                        : bService.compareTo(aService);
                  } else if (_sortBy == 'status') {
                    int getPriority(String status) {
                      switch (status) {
                        case 'Finished':
                          return 3;
                        case 'Processed':
                          return 2;
                        case 'Pending to Process':
                          return 1;
                        default:
                          return 0;
                      }
                    }

                    final aPriority = getPriority(aData['status'] ?? '');
                    final bPriority = getPriority(bData['status'] ?? '');

                    return _isAscending
                        ? aPriority.compareTo(bPriority)
                        : bPriority.compareTo(aPriority);
                  }

                  return 0;
                });

                if (filteredOrders.isEmpty) {
                  return const Center(child: Text('No orders found'));
                }

                return ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final data =
                        filteredOrders[index].data() as Map<String, dynamic>;
                    final docId = filteredOrders[index].id;
                    final userId = data['userId'];
                    final userData = _userMap[userId];

                    final userName = userData?['name'] ?? 'Unknown';
                    final userEmail = userData?['email'] ?? 'Unknown';

                    return orderCard(
                      context,
                      orderId: docId,
                      service: data['serviceType'] ?? 'Unknown',
                      price: data['totalCost']?.toString() ?? 'Rp.0',
                      status: data['status'] ?? 'Unknown',
                      userName: userName,
                      userEmail: userEmail,
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
    required String userName,
    required String userEmail,
  }) {
    List<String> statusOptions = [
      'Payment',
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
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text("ID: $orderId"),
            Text("Customer: $userName ($userEmail)"),
            Text("Price: $price"),
            const SizedBox(height: 8),
            const Text("Status: ",
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
                    textColor = const Color.fromARGB(255, 231, 178, 5);
                    break;
                  case 'Payment':
                    textColor = Colors.red;
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
                      Text(        
                        value == 'Payment' ? 'Payment is Required' : value,
                        style: TextStyle(color: textColor),),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userId = FirebaseAuth.instance.currentUser?.uid;

class WashIronPage extends StatefulWidget {
  const WashIronPage({super.key});

  @override
  State<WashIronPage> createState() => _WashIronPageState();
}

class _WashIronPageState extends State<WashIronPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final int _pricePerKg = 8000;
  int _totalCost = 0;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final Color primaryColor = const Color(0xFF05588A);
  final Color backgroundColor = const Color(0xFFF5F9FF);

  void _calculateCost(String qtyText) {
    final qty = int.tryParse(qtyText) ?? 0;
    setState(() {
      _totalCost = qty * _pricePerKg;
    });
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }
      DocumentReference orderRef = await FirebaseFirestore.instance.collection('orders').add({
        'serviceType': 'wash_iron',
        'item': _itemController.text.trim(),
        'material': _materialController.text.trim(),
        'quantity': int.parse(_quantityController.text.trim()),
        'totalCost': _totalCost,
        'createdAt': Timestamp.now(),
        'status': 'Payment',
        'paymentStatus': false, // Initial payment status (false)
        'userId': user.uid,
      });

      _formKey.currentState!.reset();
      setState(() {
        _totalCost = 0;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Wash + Iron order saved successfully'),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save order: $e')),
      );
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    _materialController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Wash + Iron'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                'New Wash + Iron Order',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in the details for the laundry order',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _itemController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g., Baju, Celana, Jas',
                  prefixIcon: Icon(Icons.checkroom, color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Item is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _materialController,
                decoration: InputDecoration(
                  labelText: 'Material',
                  hintText: 'e.g., Katun, Linen',
                  prefixIcon: Icon(Icons.texture, color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Material is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Quantity (kg)',
                  hintText: 'Enter total weight in kg',
                  prefixIcon: Icon(Icons.scale, color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: _calculateCost,
                validator: (value) {
                  final qty = int.tryParse(value ?? '') ?? 0;
                  if (qty <= 0) return 'Must be greater than 0 kg';
                  if (qty > 50) return 'Max 50 kg per order';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: primaryColor.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRICE DETAILS',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Cost',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.grey.shade700)),
                          Text(
                            'Rp$_totalCost',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: Rp$_pricePerKg / kg',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'SAVE ORDER',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

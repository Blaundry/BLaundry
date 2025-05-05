import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userId = FirebaseAuth.instance.currentUser?.uid;

class RegularWashPage extends StatefulWidget {
  const RegularWashPage({super.key});

  @override
  State<RegularWashPage> createState() => _RegularWashPageState();
}

class _RegularWashPageState extends State<RegularWashPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemModelController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final int _pricePerKg = 5000;
  int _totalCost = 0;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final Color primaryColor = const Color(0xFF05588A);
  final Color secondaryColor = const Color(0xFF29A3FF);
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
      await FirebaseFirestore.instance.collection('orders').add({
        'serviceType': 'regular',
        'item': _itemNameController.text.trim(), 
        'material': _itemModelController.text.trim(),
        'quantity': int.parse(_quantityController.text.trim()),
        'totalCost': _totalCost,
        'createdAt': Timestamp.now(),
        'status': 'In Process',
        'userId': userId,
      });

      _formKey.currentState!.reset();
      setState(() {
        _totalCost = 0;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Regular order saved successfully'),
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
    _itemNameController.dispose();
    _itemModelController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Regular Wash'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'New Order',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill the item details below',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    TextFormField(
                      controller: _itemNameController,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'e.g., Kemeja, Celana, Jaket',
                        prefixIcon: Icon(Icons.checkroom, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: primaryColor.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Item name is required';
                        }
                        if (value.length < 3) {
                          return 'Minimum 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _itemModelController,
                      decoration: InputDecoration(
                        labelText: 'Item Material',
                        hintText: 'e.g., Katun, Denim, Wol',
                        prefixIcon: Icon(Icons.texture, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: primaryColor.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Item material is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)',
                        hintText: 'Enter weight in kilograms',
                        prefixIcon: Icon(Icons.scale, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: primaryColor.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: _calculateCost,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Weight is required';
                        }
                        final qty = int.tryParse(value) ?? 0;
                        if (qty <= 0) {
                          return 'Must be greater than 0';
                        }
                        if (qty > 20) {
                          return 'Maximum 20 kg';
                        }
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
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Cost',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.grey.shade700,
                                      ),
                                ),
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
                              'Price: Rp$_pricePerKg/kg',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              )
                            : const Text(
                                'SAVE ORDER',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

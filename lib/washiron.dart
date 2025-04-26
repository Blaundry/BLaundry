import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _calculateCost(String qtyText) {
    final qty = int.tryParse(qtyText) ?? 0;
    setState(() {
      _totalCost = qty * _pricePerKg;
    });
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
      appBar: AppBar(
        title: const Text('Wash + Iron'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Item:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(
                hintText: 'Enter item',
                helperText: 'Contoh: Baju, Celana, Jas',
              ),
            ),

            const SizedBox(height: 20),
            const Text('Material:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _materialController,
              decoration: const InputDecoration(
                hintText: 'Enter material',
              ),
            ),

            const SizedBox(height: 20),
            const Text('Quantity (kg):', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'Enter quantity',
              ),
              onChanged: _calculateCost,
            ),

            const SizedBox(height: 20),
            Text(
              'Total Cost: Rp$_totalCost',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved')),
                  );
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

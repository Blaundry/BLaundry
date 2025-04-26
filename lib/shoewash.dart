import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShoeWashPage extends StatefulWidget {
  const ShoeWashPage({super.key});

  @override
  State<ShoeWashPage> createState() => _ShoeWashPageState();
}

class _ShoeWashPageState extends State<ShoeWashPage> {
  final TextEditingController _shoeTypeController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final int _pricePerShoe = 15000;
  int _totalCost = 0;

  void _calculateCost(String qtyText) {
    final qty = int.tryParse(qtyText) ?? 0;
    setState(() {
      _totalCost = qty * _pricePerShoe;
    });
  }

  @override
  void dispose() {
    _shoeTypeController.dispose();
    _materialController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoe Wash'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Shoe Type:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _shoeTypeController,
              decoration: const InputDecoration(
                hintText: 'Enter shoe type',
                helperText: 'Contoh: Sneakers, Boots',
              ),
            ),

            const SizedBox(height: 20),
            const Text('Material:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _materialController,
              decoration: const InputDecoration(
                hintText: 'Enter shoe material',
                helperText: 'Contoh: Kulit, Kanvas',
              ),
            ),

            const SizedBox(height: 20),
            const Text('Qty:', style: TextStyle(fontWeight: FontWeight.bold)),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _calculateCost(String qtyText) {
    final qty = int.tryParse(qtyText) ?? 0;
    setState(() {
      _totalCost = qty * _pricePerKg;
    });
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
      appBar: AppBar(
        title: const Text('Regular Wash'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Item Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(
                hintText: 'Enter item name',
                helperText: 'Contoh: Kemeja, Celana, Jaket',
              ),
            ),

            const SizedBox(height: 20),
            const Text('Item Model:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _itemModelController,
              decoration: const InputDecoration(
                hintText: 'Enter item model',
                helperText: 'Contoh: Katun, Denim, Wol',
              ),
            ),

            const SizedBox(height: 20),
            const Text('Item Qty:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'Enter quantity',
                helperText: 'in kilograms',
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

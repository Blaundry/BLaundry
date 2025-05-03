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
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final Color primaryColor = const Color(0xFF05588A);
  final Color backgroundColor = const Color(0xFFF5F9FF);

  void _calculateCost(String qtyText) {
    final qty = int.tryParse(qtyText) ?? 0;
    setState(() {
      _totalCost = qty * _pricePerShoe;
    });
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (!mounted) return;

    _formKey.currentState!.reset();
    setState(() => _totalCost = 0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Order saved successfully'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Shoe Wash'),
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
                'New Shoe Order',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill the shoe details below',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _shoeTypeController,
                decoration: InputDecoration(
                  labelText: 'Shoe Type',
                  hintText: 'e.g., Sneakers, Boots',
                  prefixIcon: Icon(Icons.directions_walk, color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Shoe type is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _materialController,
                decoration: InputDecoration(
                  labelText: 'Material',
                  hintText: 'e.g., Kulit, Kanvas',
                  prefixIcon: Icon(Icons.texture, color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Material is required';
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
                  labelText: 'Quantity',
                  hintText: 'Enter number of shoes',
                  prefixIcon:
                      Icon(Icons.format_list_numbered, color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: _calculateCost,
                validator: (value) {
                  final qty = int.tryParse(value ?? '') ?? 0;
                  if (qty <= 0) return 'Must be greater than 0';
                  if (qty > 10) return 'Maximum 10 pairs';
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
                        'Price: Rp$_pricePerShoe / pair',
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

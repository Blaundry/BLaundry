import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'transfer';
  String? _qrToken;
  final Uuid _uuid = const Uuid();

  // Design constants
  static const _primaryColor = Color(0xFF4361EE);
  static const _secondaryColor = Color(0xFF3F37C9);
  static const _successColor = Color(0xFF2A9D8F);

  @override
  void initState() {
    super.initState();
    _generateQRToken();
  }

  void _generateQRToken() {
    setState(() {
      _qrToken = _uuid.v4(); // Generate unique token
    });
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Method",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildPaymentOption(
                icon: Icons.account_balance,
                title: "Bank Transfer",
                value: 'transfer',
              ),
              const Divider(height: 1, indent: 16),
              _buildPaymentOption(
                icon: Icons.qr_code,
                title: "QR Payment",
                value: 'qr',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor),
      title: Text(title),
      trailing: Radio<String>(
        value: value,
        groupValue: _selectedMethod,
        activeColor: _primaryColor,
        onChanged: (String? value) {
          if (value != null) {
            setState(() => _selectedMethod = value);
            if (value == 'qr') _generateQRToken();
          }
        },
      ),
      onTap: () {
        setState(() => _selectedMethod = value);
        if (value == 'qr') _generateQRToken();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildTransferDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bank Transfer Details",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildBankDetailRow("Bank Name", "BCA"),
              const Divider(height: 24),
              _buildBankDetailRow("Account Number", "1234 5678 9012"),
              const Divider(height: 24),
              _buildBankDetailRow("Account Holder", "PT Laundry Bersih"),
              const Divider(height: 24),
              _buildBankDetailRow("Amount", "Rp 85.000"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildQRPayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "QR Payment",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _qrToken != null
                    ? QrImageView(
                        data: _qrToken!,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                      )
                    : const CircularProgressIndicator(),
              ),
              const SizedBox(height: 16),
              Text(
                "Scan this QR code to pay",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              if (_qrToken != null)
                Text(
                  "Token: $_qrToken",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentMethodSelector(),
            const SizedBox(height: 24),
            _selectedMethod == 'transfer'
                ? _buildTransferDetails()
                : _buildQRPayment(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Payment method selected"),
                      backgroundColor: _successColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirm Payment",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = 'transfer';
  String? qrToken;

  void generateQRToken() {
    var uuid = const Uuid();
    setState(() {
      qrToken = uuid.v4(); // Generate token unik
    });
  }

  @override
  void initState() {
    super.initState();
    generateQRToken(); // Generate pertama kali
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Choose Payment Method:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("Transfer"),
                    value: 'transfer',
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("QR Code"),
                    value: 'qr',
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value!;
                        generateQRToken(); // Regenerate token saat pilih QR
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            if (selectedMethod == 'transfer') ...[
              const Text("Bank Account Info:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Bank: BCA"),
              const Text("Account No: 1234567890"),
              const Text("Name: PT Laundry Bersih"),
            ] else if (selectedMethod == 'qr') ...[
              const Text("Scan QR Code untuk membayar:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Center(
                child: qrToken != null
                    ? QrImageView(
                        data: qrToken!,
                        version: QrVersions.auto,
                        size: 200.0,
                      )
                    : const CircularProgressIndicator(),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Token: $qrToken",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

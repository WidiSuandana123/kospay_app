import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kospay_app/models/room_model.dart';

class PaymentScreen extends StatefulWidget {
  final RoomModel room;
  final String kostId;

  const PaymentScreen({super.key, required this.room, required this.kostId});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    try {
      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Update room availability in Firestore
      await FirebaseFirestore.instance
          .collection('kost')
          .doc(widget.kostId) // Dokumen ID KOST
          .collection('rooms')
          .doc(widget.room
              .id) // Gunakan widget.room.id untuk merujuk ke dokumen yang sesuai
          .update({'isAvailable': false});

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment processed successfully')),
      );

      // Navigate back to the home screen
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room: ${widget.room.name}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Price: Rp ${widget.room.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Select Payment Method:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            RadioListTile<String>(
              title: const Text('Credit Card'),
              value: 'credit_card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Bank Transfer'),
              value: 'bank_transfer',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _processPayment,
              child: const Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

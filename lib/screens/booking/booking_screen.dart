// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/models/room_model.dart';
import 'package:kospay_app/cubit/booking_cubit.dart';
import 'package:kospay_app/models/booking_model.dart';
import 'package:intl/intl.dart';

class BookingFormScreen extends StatefulWidget {
  final RoomModel room;

  const BookingFormScreen({super.key, required this.room});

  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.room.name}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildRoomInfoCard(),
                const SizedBox(height: 24),
                _buildDateSelectionSection(),
                const SizedBox(height: 24),
                _buildPaymentMethodSection(),
                const SizedBox(height: 32),
                _buildBookButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.room.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${widget.room.price}/night',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Dates',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateButton(
                'Check-in',
                _startDate,
                () => _selectDate(true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateButton(
                'Check-out',
                _endDate,
                () => _selectDate(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateButton(
      String label, DateTime? date, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          Text(label),
          const SizedBox(height: 4),
          Text(
            date == null ? 'Select' : DateFormat('MMM dd, yyyy').format(date),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedPaymentMethod,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          items: ['Credit Card', 'Bank Transfer'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedPaymentMethod = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a payment method';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBookButton() {
    return ElevatedButton(
      onPressed: _submitBooking,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Book and Pay Now',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          isStartDate ? DateTime.now() : (_startDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : (_startDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null &&
        _selectedPaymentMethod != null) {
      final booking = BookingModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'currentUserId', // Ganti dengan ID pengguna aktual
        roomId: widget.room.id,
        kostId: widget.room.kostId,
        checkinDate: _startDate!,
        checkoutDate: _endDate!,
        totalPrice:
            (widget.room.price * _endDate!.difference(_startDate!).inDays)
                .toInt(), // Ubah ke int
        status: 'pending',
        paymentStatus: 'unpaid',
        paymentMethod: _selectedPaymentMethod!,
      );

      context.read<BookingCubit>().createBooking(booking);

      _showBookingConfirmationDialog(booking);
    }
  }

  void _showBookingConfirmationDialog(BookingModel booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Room: ${widget.room.name}'),
                Text(
                    'Check-in: ${DateFormat('MMM dd, yyyy').format(booking.checkinDate)}'),
                Text(
                    'Check-out: ${DateFormat('MMM dd, yyyy').format(booking.checkoutDate)}'),
                Text('Total Price: \$${booking.totalPrice}'),
                Text('Payment Method: ${booking.paymentMethod}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm and Pay'),
              onPressed: () {
                // Implement payment process here
                // For now, we'll just update the booking status
                context
                    .read<BookingCubit>()
                    .updateBookingStatus(booking.id, 'confirmed');
                context
                    .read<BookingCubit>()
                    .updatePaymentStatus(booking.id, 'paid');
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to previous screen
              },
            ),
          ],
        );
      },
    );
  }
}

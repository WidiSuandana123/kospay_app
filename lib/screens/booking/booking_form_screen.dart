// lib/screens/booking/booking_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/booking_cubit.dart';
import 'package:kospay_app/models/booking_model.dart';
import 'package:kospay_app/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingFormScreen extends StatefulWidget {
  final RoomModel room;

  const BookingFormScreen({super.key, required this.room});

  @override
  // ignore: library_private_types_in_public_api
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _checkIn;
  late DateTime _checkOut;

  @override
  void initState() {
    super.initState();
    _checkIn = DateTime.now();
    _checkOut = DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Room')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room: ${widget.room.name}'),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Check-in Date'),
                readOnly: true,
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_checkIn),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _checkIn,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _checkIn = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Check-out Date'),
                readOnly: true,
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_checkOut),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _checkOut,
                    firstDate: _checkIn.add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _checkOut = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createBooking();
                  }
                },
                child: const Text('Book Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to book a room')),
      );
      return;
    }

    final booking = BookingModel(
      id: FirebaseFirestore.instance.collection('bookings').doc().id,
      roomId: widget.room.id,
      kostId:
          widget.room.kostId, // Assuming the RoomModel has a kostId property
      userId: user.uid,
      checkinDate: _checkIn,
      checkoutDate: _checkOut,
      paymentStatus: 'pending',
      totalPrice:
          (widget.room.price * _checkOut.difference(_checkIn).inDays).toInt(),
      paymentMethod: 'cash', // Replace with the actual payment method
      status: 'pending', // Replace with the actual status
    );

    context.read<BookingCubit>().createBooking(booking);

    // Here you would typically integrate with your payment gateway
    // For this example, we'll just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking created successfully')),
    );

    Navigator.of(context).pop();
  }
}

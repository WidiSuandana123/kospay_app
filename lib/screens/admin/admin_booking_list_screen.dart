import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/booking_cubit.dart';
import 'package:kospay_app/models/booking_model.dart';
import 'package:intl/intl.dart';

class AdminBookingListScreen extends StatelessWidget {
  const AdminBookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BookingCubit>().getBookingsByUserId('userId');

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Bookings')),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingsLoaded) {
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                BookingModel booking = state.bookings[index];
                return ListTile(
                  title: Text('Room ID: ${booking.roomId}'),
                  subtitle: Text(
                      '${DateFormat('yyyy-MM-dd').format(booking.checkinDate)} - ${DateFormat('yyyy-MM-dd').format(booking.checkoutDate)}'),
                  trailing: Text('Status: ${booking.status}'),
                  onTap: () => _showBookingDetails(context, booking),
                );
              },
            );
          } else if (state is BookingError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No bookings available'));
        },
      ),
    );
  }

  void _showBookingDetails(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('User ID: ${booking.userId}'),
              Text('Room ID: ${booking.roomId}'),
              Text('Kost ID: ${booking.kostId}'),
              Text(
                  'Check-in Date: ${DateFormat('yyyy-MM-dd').format(booking.checkinDate)}'),
              Text(
                  'Check-out Date: ${DateFormat('yyyy-MM-dd').format(booking.checkoutDate)}'),
              Text('Total Price: ${booking.totalPrice}'),
              Text('Payment Status: ${booking.paymentStatus}'),
              Text('Payment Method: ${booking.paymentMethod}'),
              Text('Status: ${booking.status}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Update Status'),
              onPressed: () => _showUpdateStatusDialog(context, booking),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateStatusDialog(BuildContext context, BookingModel booking) {
    String newStatus = booking.status;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Booking Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: newStatus,
                items:
                    ['pending', 'confirmed', 'cancelled'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      newStatus = value;
                    });
                  }
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                context
                    .read<BookingCubit>()
                    .updateBookingStatus(booking.id, newStatus);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

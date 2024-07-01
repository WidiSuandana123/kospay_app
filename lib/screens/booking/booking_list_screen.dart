import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/booking_cubit.dart';
import 'package:kospay_app/models/booking_model.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<BookingCubit>()
        .getBookingsByUserId('currentUserId'); // Replace with actual user ID

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
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
                    '${booking.checkinDate.toString().substring(0, 10)} - ${booking.checkoutDate.toString().substring(0, 10)}',
                  ),
                  trailing: Text('Status: ${booking.status}'),
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
}

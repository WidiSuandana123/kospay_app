import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/room_cubit.dart';
import 'package:kospay_app/models/room_model.dart';
import 'package:kospay_app/screens/room/payment_screen.dart';

class RoomDetailScreen extends StatelessWidget {
  final String roomId;
  final String kostId;

  const RoomDetailScreen(
      {super.key, required this.roomId, required this.kostId});

  @override
  Widget build(BuildContext context) {
    context.read<RoomCubit>().getRoomById(kostId, roomId);

    return Scaffold(
      appBar: AppBar(title: const Text('Room Detail')),
      body: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          if (state is RoomLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RoomLoaded) {
            RoomModel room = state.room;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${room.name}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Price: Rp ${room.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  Text('Description: ${room.description}'),
                  const SizedBox(height: 8),
                  Text(
                      'Status: ${room.isAvailable ? "Available" : "Not Available"}'),
                  const SizedBox(height: 16),
                  if (room.isAvailable)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                PaymentScreen(room: room, kostId: kostId),
                          ),
                        );
                      },
                      child: const Text('Proceed to Payment'),
                    ),
                ],
              ),
            );
          } else if (state is RoomError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Room not found'));
        },
      ),
    );
  }
}

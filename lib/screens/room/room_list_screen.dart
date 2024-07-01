import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/room_cubit.dart';
import 'package:kospay_app/models/room_model.dart';
import 'package:kospay_app/screens/room/room_detail_screen.dart';

class RoomListScreen extends StatelessWidget {
  final String kostId;

  const RoomListScreen(
      {super.key, required this.kostId, required String roomId});

  @override
  Widget build(BuildContext context) {
    context.read<RoomCubit>().getRoomsByKostId(kostId);

    return Scaffold(
      appBar: AppBar(title: const Text('Rooms')),
      body: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          if (state is RoomLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RoomsLoaded) {
            return ListView.builder(
              itemCount: state.rooms.length,
              itemBuilder: (context, index) {
                RoomModel room = state.rooms[index];
                return ListTile(
                  title: Text(room.name),
                  subtitle: Text('Rp ${room.price.toStringAsFixed(2)}'),
                  trailing: Icon(
                    room.isAvailable ? Icons.check_circle : Icons.cancel,
                    color: room.isAvailable ? Colors.green : Colors.red,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RoomDetailScreen(
                          roomId: room.id,
                          kostId: kostId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is RoomError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No rooms available'));
        },
      ),
    );
  }
}

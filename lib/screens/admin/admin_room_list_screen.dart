import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/room_cubit.dart';
import 'package:kospay_app/models/room_model.dart';
import 'package:kospay_app/screens/room/room_form_screen.dart';
import 'package:kospay_app/screens/room/room_detail_screen.dart';

class AdminRoomListScreen extends StatelessWidget {
  final String kostId;

  const AdminRoomListScreen({super.key, required this.kostId});

  @override
  Widget build(BuildContext context) {
    context.read<RoomCubit>().getRoomsByKostId(kostId);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Rooms')),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        room.isAvailable ? Icons.check_circle : Icons.cancel,
                        color: room.isAvailable ? Colors.green : Colors.red,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RoomFormScreen(kostId: kostId, room: room),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmation(context, room),
                      ),
                    ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomFormScreen(kostId: kostId)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, RoomModel room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Room'),
          content: const Text('Are you sure you want to delete this room?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                context.read<RoomCubit>().deleteRoom(kostId, room.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/models/room_model.dart';
import 'package:equatable/equatable.dart';
import 'package:kospay_app/services/room_service.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RoomCubit(RoomService roomService) : super(RoomInitial());

  Future<void> getRoomsByKostId(String kostId) async {
    try {
      emit(RoomLoading());
      final roomsSnapshot = await _firestore
          .collection('kost')
          .doc(kostId)
          .collection('rooms')
          .get();

      final rooms = roomsSnapshot.docs
          .map((doc) => RoomModel.fromMap(doc.data()..['id'] = doc.id))
          .toList();

      emit(RoomsLoaded(rooms));
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }

  Future<void> getRoomById(String kostId, String roomId) async {
    try {
      emit(RoomLoading());
      final roomDoc = await _firestore
          .collection('kost')
          .doc(kostId)
          .collection('rooms')
          .doc(roomId)
          .get();

      if (roomDoc.exists) {
        final room = RoomModel.fromMap(roomDoc.data()!..['id'] = roomDoc.id);
        emit(RoomLoaded(room));
      } else {
        emit(const RoomError('Room not found'));
      }
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }

  Future<void> createRoom(RoomModel room) async {
    try {
      emit(RoomLoading());
      await _firestore
          .collection('kost')
          .doc(room.kostId)
          .collection('rooms')
          .doc(room.id)
          .set(room.toMap());
      emit(RoomLoaded(room));
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }

  Future<void> updateRoom(RoomModel room) async {
    try {
      emit(RoomLoading());
      await _firestore
          .collection('kost')
          .doc(room.kostId)
          .collection('rooms')
          .doc(room.id)
          .update(room.toMap());
      emit(RoomLoaded(room));
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }

  Future<void> deleteRoom(String kostId, String roomId) async {
    try {
      emit(RoomLoading());
      await _firestore
          .collection('kost')
          .doc(kostId)
          .collection('rooms')
          .doc(roomId)
          .delete();
      emit(RoomInitial());
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }
}

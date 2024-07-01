import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kospay_app/models/room_model.dart';

class RoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RoomModel>> getRoomsByKostId(String kostId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('rooms')
          .where('kostId', isEqualTo: kostId)
          .get();
      return snapshot.docs
          .map((doc) => RoomModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }

  Future<RoomModel?> getRoomById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('rooms').doc(id).get();
      if (doc.exists) {
        return RoomModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<bool> createRoom(RoomModel room) async {
    try {
      await _firestore.collection('rooms').doc(room.id).set(room.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<bool> updateRoom(RoomModel room) async {
    try {
      await _firestore.collection('rooms').doc(room.id).update(room.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<bool> deleteRoom(String id) async {
    try {
      await _firestore.collection('rooms').doc(id).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<RoomModel> getRoomModelFromRoomId(String roomId) async {
    RoomModel? room = await getRoomById(roomId);
    if (room != null) {
      return room;
    } else {
      throw Exception('Room not found with id $roomId');
    }
  }
}

// lib/services/booking_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kospay_app/models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BookingModel>> getBookingsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map(
              (doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }

  Future<bool> createBooking(BookingModel booking) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(booking.id)
          .set(booking.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(bookingId)
          .update({'status': status});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }
}

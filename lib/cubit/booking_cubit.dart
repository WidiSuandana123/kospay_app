// lib/cubit/booking_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/models/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kospay_app/services/booking_service.dart';
import 'package:kospay_app/services/payment_service.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingService _bookingService;

  BookingCubit(this._bookingService, PaymentService paymentService)
      : super(BookingInitial());

  Future<void> getBookingsByUserId(String userId) async {
    try {
      emit(BookingLoading());
      final List<BookingModel> bookings =
          await _bookingService.getBookingsByUserId(userId);
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> createBooking(BookingModel booking) async {
    try {
      emit(BookingLoading());
      final bool isCreated = await _bookingService.createBooking(booking);
      if (isCreated) {
        emit(BookingSuccess());
      } else {
        emit(BookingError('Failed to create booking'));
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> getBookingById(String bookingId) async {
    try {
      emit(BookingLoading());
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .get();

      if (doc.exists) {
        final booking =
            BookingModel.fromMap(doc.data() as Map<String, dynamic>);
        emit(BookingLoaded(booking));
      } else {
        emit(BookingError('Booking not found'));
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      emit(BookingLoading());
      final bool isUpdated =
          await _bookingService.updateBookingStatus(bookingId, status);
      if (isUpdated) {
        emit(BookingSuccess());
      } else {
        emit(BookingError('Failed to update booking status'));
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> updatePaymentStatus(
      String bookingId, String paymentStatus) async {
    try {
      emit(BookingLoading());
      // Implement payment status update logic here
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}

// lib/cubit/booking_state.dart
part of 'booking_cubit.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {}

class BookingLoaded extends BookingState {
  final BookingModel booking;
  BookingLoaded(this.booking);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class BookingsLoaded extends BookingState {
  final List<BookingModel> bookings;
  BookingsLoaded(this.bookings);
}

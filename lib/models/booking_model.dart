import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String id;
  String roomId;
  String kostId;
  String userId;
  DateTime checkinDate;
  DateTime checkoutDate;
  int totalPrice;
  String paymentStatus;
  String paymentMethod;
  String status;

  BookingModel({
    required this.id,
    required this.roomId,
    required this.kostId,
    required this.userId,
    required this.checkinDate,
    required this.checkoutDate,
    required this.totalPrice,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.status,
  });

  // Tambahkan metode fromMap
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      roomId: map['roomId'],
      kostId: map['kostId'],
      userId: map['userId'],
      checkinDate: (map['checkinDate'] as Timestamp).toDate(),
      checkoutDate: (map['checkoutDate'] as Timestamp).toDate(),
      totalPrice: map['totalPrice'],
      paymentStatus: map['paymentStatus'],
      paymentMethod: map['paymentMethod'],
      status: map['status'],
    );
  }

  // Tambahkan metode toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'kostId': kostId,
      'userId': userId,
      'checkinDate': Timestamp.fromDate(checkinDate),
      'checkoutDate': Timestamp.fromDate(checkoutDate),
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }
}

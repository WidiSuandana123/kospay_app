import 'package:flutter/material.dart';
import 'package:kospay_app/models/room_model.dart';
import 'package:kospay_app/screens/booking/booking_form_screen.dart';
import 'package:kospay_app/screens/auth/login_screen.dart';
import 'package:kospay_app/screens/home_screen.dart';
import 'package:kospay_app/screens/kost/kost_detail_screen.dart';
import 'package:kospay_app/screens/kost/kost_form_screen.dart';
import 'package:kospay_app/screens/kost/kost_list_screen.dart';
import 'package:kospay_app/screens/room/room_detail_screen.dart';
import 'package:kospay_app/screens/room/room_form_screen.dart';
import 'package:kospay_app/screens/search/search_screen.dart';
import 'package:kospay_app/screens/room/room_list_screen.dart';
import 'package:kospay_app/screens/auth/admin_screen.dart';
import 'package:kospay_app/screens/admin/admin_kost_list_screen.dart';
import 'package:kospay_app/screens/admin/admin_room_list_screen.dart';
import 'package:kospay_app/screens/profile/profile_screen.dart';
import 'package:kospay_app/services/room_service.dart';

RoomService roomService = RoomService();

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginScreen(),
  // '/register': (context) => SignUpScreen(),
  '/kosts': (context) => const KostListScreen(),
  '/kost_detail': (context) => const KostDetailScreen(
        kostId: '',
      ),
  '/kost_form': (context) => const KostFormScreen(),
  '/rooms': (context) => const RoomListScreen(
        kostId: '',
        roomId: '',
      ),
  '/room_detail': (context) => const RoomDetailScreen(
        roomId: '',
        kostId: '',
      ),
  '/room_form': (context) => const RoomFormScreen(
        kostId: '',
      ),
  '/search': (context) => const SearchScreen(),
  '/home': (context) => const HomeScreen(),
  '/admin': (context) => const AdminScreen(),
  '/admin/kosts': (context) => const AdminKostListScreen(),
  '/admin/rooms': (context) => const AdminRoomListScreen(
        kostId: 'kostId',
      ),
  '/admin/bookings/:roomId': (context) => FutureBuilder(
        future: roomService.getRoomModelFromRoomId(
          ModalRoute.of(context)!.settings.arguments
              as String, // cast to String
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BookingFormScreen(
                room: snapshot.data as RoomModel); // cast to RoomModel
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
  '/profile': (context) => const ProfileScreen(),
  '/login': (context) => const LoginScreen(),
};

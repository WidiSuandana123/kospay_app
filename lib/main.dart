import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kospay_app/cubit/booking_cubit.dart';
import 'package:kospay_app/services/booking_service.dart';
import 'package:kospay_app/services/kost_service.dart';
import 'package:kospay_app/services/payment_service.dart';
import 'package:kospay_app/services/room_service.dart';
import 'package:kospay_app/widgets/notification_overlay.dart';
import 'cubit/kost_cubit.dart';
import 'cubit/room_cubit.dart';
import 'package:kospay_app/config/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print("Foreground message received: ${message.data}");
    }
    if (message.notification != null) {
      if (kDebugMode) {
        print("Notification: ${message.notification!.title}");
        print("Body: ${message.notification!.body}");
      }
    }

    if (message.data['type'] == 'profile_update') {
      final overlay = navigatorKey.currentState?.overlay;
      if (overlay != null) {
        final notificationOverlayState =
            overlay.context.findAncestorStateOfType<NotificationOverlayState>();
        notificationOverlayState?.showNotification(
            "Please update your profile to complete your account setup.");
      }
    }
  });

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookingCubit>(
          create: (context) => BookingCubit(BookingService(), PaymentService()),
        ),
        BlocProvider<KostCubit>(
          create: (context) => KostCubit(KostService()),
        ),
        BlocProvider<RoomCubit>(
          create: (context) => RoomCubit(RoomService()),
        ),
      ],
      child: MaterialApp(
        // Ensure this MaterialApp is the root of your widget tree
        navigatorKey: navigatorKey,
        title: 'KosPay',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          hintColor: Colors.deepPurpleAccent,
          textTheme: TextTheme(
            displayLarge: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            displayMedium: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            bodyLarge:
                TextStyle(fontSize: 14, color: Colors.deepPurpleAccent[600]),
            bodyMedium:
                TextStyle(fontSize: 12, color: Colors.deepPurpleAccent[600]),
          ),
        ),
        initialRoute: '/',
        routes: appRoutes,
        builder: (context, child) {
          return NotificationOverlay(
              child: child!); // Wrap child with NotificationOverlay
        },
      ),
    );
  }
}

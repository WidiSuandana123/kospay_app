import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kospay_app/screens/auth/admin_screen.dart';
import 'package:kospay_app/screens/home_screen.dart';

class RoleRouter extends StatefulWidget {
  const RoleRouter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RoleRouterState createState() => _RoleRouterState();
}

class _RoleRouterState extends State<RoleRouter> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Stream<DocumentSnapshot> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream =
        _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text('No user data found'),
            ),
          );
        }

        // Get user role from Firestore
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        String role = data['role'] ?? 'user';

        // Redirect based on role
        if (role == 'admin') {
          return const AdminScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}

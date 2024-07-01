import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp(String email, String password, String role) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan informasi pengguna dan peran mereka di Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
      });

      return null; // Tidak ada pesan error
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return e.toString(); // Return error message
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Tidak ada pesan error
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return e.toString(); // Return error message
    }
  }
}

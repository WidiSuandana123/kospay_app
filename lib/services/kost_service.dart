import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kospay_app/models/kost_model.dart';

class KostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<KostModel>> getKosts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('kosts').get();
      return snapshot.docs
          .map((doc) => KostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }

  Future<KostModel?> getKostById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('kost').doc(id).get();
      if (doc.exists) {
        return KostModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<bool> createKost(KostModel kost) async {
    try {
      await _firestore.collection('kosts').doc(kost.id).set(kost.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<bool> updateKost(KostModel kost) async {
    try {
      await _firestore.collection('kosts').doc(kost.id).update(kost.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<bool> deleteKost(String id) async {
    try {
      await _firestore.collection('kosts').doc(id).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }
}

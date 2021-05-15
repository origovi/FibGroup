import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static Future<QuerySnapshot> usuaris() async {
    var result = await FirebaseFirestore.instance.collection('usuaris').get();
    return result;
  }

  static Future<List<Map<String, dynamic>>> assignaturesUsuari(String email) async {
    var result = await FirebaseFirestore.instance
        .collection('usuaris')
        .limit(1)
        .where('email', isEqualTo: email)
        .get();
    return List<Map<String, dynamic>>.from(result.docs[0].data()['assignatures']);
  }

  static Future<QuerySnapshot> assignatures() async {
    var result = await FirebaseFirestore.instance.collection('asignaturas').get();
    return result;
  }

  static Future<QuerySnapshot> grups() async {
    var result = await FirebaseFirestore.instance.collection('grups').get();
    return result;
  }

  static Future<void> afegirAssig(
      {@required String email,
      @required List<Map<String, dynamic>> mevesAssigs,
      @required String assigId,
      @required List<String> assigUsuaris}) async {
    await FirebaseFirestore.instance
        .collection('usuaris')
        .doc(email)
        .update({'assignatures': mevesAssigs});
    await FirebaseFirestore.instance
        .collection('asignaturas')
        .doc(assigId)
        .update({'usuaris': assigUsuaris});
  }
}

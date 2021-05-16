import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibgroup/models/Grup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static Stream<QuerySnapshot> missatges(String email) {
    return FirebaseFirestore.instance
        .collection('missatges')
        .where('email', isEqualTo: email)
        .snapshots();
  }

  static Future<QuerySnapshot> usuaris() async {
    var result = await FirebaseFirestore.instance.collection('usuaris').get();
    return result;
  }

  static Future<void> comprobaICreaUsuari(User user) async {
    var res = await FirebaseFirestore.instance
        .collection('usuaris')
        .limit(1)
        .where('email', isEqualTo: user.email)
        .get();
    
    // creem l'usuari
    if (res.size == 0) {
      await FirebaseFirestore.instance.collection('usuaris').doc(user.email).set({'email': user.email, 'assignatures': [], 'descripcio': "Soy una persona muy trabajadora y amigable", 'nom': user.displayName, 'photoURL': user.photoURL});
    }
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

  static Future<String> creaGrup(
      {@required Grup grup,
      @required String assigId,
      @required Map<String, dynamic> assigGrups,
      @required String subgrup}) async {
    // actualitzem la coleccio de grups
    var res = await FirebaseFirestore.instance.collection('grups').add({
      'nom': grup.nom,
      'descripcio': grup.descripcio,
      'membres': grup.membres.map((e) => e.email).toList()
    });
    String grupId = res.id;
    // actualitzem la assignatura
    assigGrups[subgrup].add(grupId);
    await FirebaseFirestore.instance
        .collection('asignaturas')
        .doc(assigId)
        .update({'grups': assigGrups});
    return grupId;
  }

  static Future<void> actualitzaGrup(String grupId, Map<String, dynamic> update) async {
    await FirebaseFirestore.instance.collection('grups').doc(grupId).update(update);
  }

  static Future<void> enviaInvitacio(
      {@required String assigId,
      @required String receptor,
      @required String emisor,
      @required String subgrup,
      @required String missatge}) async {
    await FirebaseFirestore.instance.collection('missatges').add({
      'email': receptor,
      'emisor': emisor,
      'missatge': missatge,
      'subgrup': subgrup,
      'assigId': assigId,
    });
  }

  static Future<void> eliminaInvitacio(String idInvitacio) async {
    await FirebaseFirestore.instance.collection('missatges').doc(idInvitacio).delete();
  }
}

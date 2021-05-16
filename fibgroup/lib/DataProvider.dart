import 'package:fibgroup/DatabaseService.dart';
import 'package:fibgroup/models/Assignatura.dart';
import 'package:fibgroup/models/Grup.dart';
import 'package:fibgroup/models/Usuari.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DataProvider extends ChangeNotifier {
  final BuildContext context;

  String email;

  DataProvider(this.context);

  Map<String, Assignatura> _assigData;
  Map<String, Usuari> _usuariData;
  Map<String, Grup> _grupData;
  List<Map<String, dynamic>> _mevesAssigs;

  void init(String email) {
    this.email = email;
  }

  Future<bool> refresh([User user]) async {
    // creem un usuari nou si no existeix
    if (user != null) await DatabaseService.comprobaICreaUsuari(user);

    // Update usuariData
    _usuariData = {};
    var dbUsuaris = await DatabaseService.usuaris();
    for (var i = 0; i < dbUsuaris.size; i++) {
      var dbUsuari = dbUsuaris.docs[i];
      _usuariData[dbUsuari.id] = Usuari.fromRaw(dbUsuari.data());
    }

    // Update assigData
    _assigData = {};
    var dbAssigs = await DatabaseService.assignatures();
    for (var i = 0; i < dbAssigs.size; i++) {
      var dbAssig = dbAssigs.docs[i];
      _assigData[dbAssig.id] = Assignatura.fromRaw(dbAssig.data(), dbAssig.id);
    }

    // Update assigData
    _grupData = {};
    var dbGrups = await DatabaseService.grups();
    for (var i = 0; i < dbGrups.size; i++) {
      var dbGrup = dbGrups.docs[i];
      List<String> membresGrup = List<String>.from(dbGrup['membres']);
      List<Usuari> usuarisGrup = membresGrup.map((element) => _usuariData[element]).toList();
      _grupData[dbGrup.id] = Grup(
          id: dbGrup.id,
          nom: dbGrup['nom'],
          membres: usuarisGrup,
          descripcio: dbGrup['descripcio']);
    }

    // Update mevesAssigs
    _mevesAssigs = await DatabaseService.assignaturesUsuari(this.email);
    return true;
  }

  Usuari get usuariActual => _usuariData[this.email];

  void newAssigsData(Map<String, Assignatura> data) {
    _assigData = data;
  }

  List<Assignatura> assignaturesPerIds(List<String> ids) {
    List<Assignatura> res = [];
    ids.forEach((element) {
      if (_assigData.containsKey(element)) {
        res.add(_assigData[element]);
      }
    });
    return res;
  }

  List<Assignatura> assignaturesPerTipus(String tipus) {
    List<Assignatura> res = [];
    _assigData.forEach((key, value) {
      if (value.tipus == tipus) {
        res.add(value);
      }
    });
    return res;
  }

  List<Assignatura> assignaturesPerEspecialitat(String especialitat) {
    List<Assignatura> res = [];
    _assigData.forEach((key, value) {
      if (value.especialitat == especialitat) {
        res.add(value);
      }
    });
    return res;
  }

  List<Map<String, dynamic>> mevesAssigs() {
    return _mevesAssigs.map((e) => {'assig': _assigData[e['id']], 'grup': e['grup']}).toList();
  }

  List<Grup> grupsAssig(Assignatura assig, String subgrup) {
    List<String> grupIds = List<String>.from(assig.grups[subgrup]);
    return grupIds.map((e) => _grupData[e]).toList();
  }

  List<Usuari> membresAssig(Assignatura assig) {
    return assig.usuaris.map((e) => _usuariData[e]).toList();
  }

  Grup grupDelMembre(Assignatura assig, String subgrup, Usuari usuari) {
    for (String grupId in assig.grups[subgrup]) {
      if (_grupData[grupId].membres.contains(usuari)) return _grupData[grupId];
    }
    return null;
  }

  Assignatura assigById(String assigId) {
    return _assigData[assigId];
  }

  Usuari usuariByEmail(String email) {
    return _usuariData[email];
  }

  String subgrupMeu(String assigId) {
    for (var map in _mevesAssigs) {
      if (map['id'] == assigId) return map['grup'];
    }
    return "";
  }

  // MODIFICADORS
  Future<void> afegirAssig(Assignatura assig, dynamic nomGrup) async {
    bool usuariTeniaAssig = false;
    _mevesAssigs.forEach((element) {
      if (element['id'] == assig.id) usuariTeniaAssig = true;
    });
    if (!usuariTeniaAssig) {
      _mevesAssigs.add({'grup': nomGrup, 'id': assig.id});
      assig.usuaris.add(this.email);
      await DatabaseService.afegirAssig(
          email: this.email,
          mevesAssigs: _mevesAssigs,
          assigId: assig.id,
          assigUsuaris: assig.usuaris);
    }
  }

  Future<void> afegirUsuariAGrup(String grupId) async {
    _grupData[grupId].membres.add(this.usuariActual);
    await DatabaseService.actualitzaGrup(
        grupId, {'membres': _grupData[grupId].membres.map((e) => e.email).toList()});
  }

  Future<void> creaGrup(
      {@required Assignatura assig,
      @required String subgrup,
      @required String nom,
      @required String descripcio}) async {
    Grup grup = Grup(nom: nom, descripcio: descripcio, membres: [usuariActual]);
    String grupId = await DatabaseService.creaGrup(
        grup: grup, assigId: assig.id, assigGrups: assig.grups, subgrup: subgrup);
    _grupData[grupId] = grup;
    assig.grups[subgrup].add(grupId);
  }

  Future<void> enviaInvitacio(
      {@required Assignatura assig,
      @required Usuari receptor,
      @required String subgrup,
      @required String missatge}) async {
    await DatabaseService.enviaInvitacio(
        assigId: assig.id,
        receptor: receptor.email,
        emisor: this.email,
        subgrup: subgrup,
        missatge: missatge);
  }
}

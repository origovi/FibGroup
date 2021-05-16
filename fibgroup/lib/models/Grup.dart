import 'package:fibgroup/models/Usuari.dart';
import 'package:flutter/material.dart';

class Grup {
  String id;
  String nom;
  String descripcio;
  List<Usuari> membres;

  Grup({this.id, @required this.nom, @required this.membres, @required this.descripcio});

  Grup.fromRaw(Map<String, dynamic> data, String id) {
    this.id = id;
    this.nom = data['nom'];
    this.membres = List<Usuari>.from(data['membres']);
  }
}
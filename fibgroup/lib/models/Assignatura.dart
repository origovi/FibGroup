import 'package:fibgroup/models/Pair.dart';

class Assignatura {
  String id;
  String nom;
  String acronim;
  String tipus;
  int maxNumIntegrants;
  Map<String, dynamic> grups;
  String especialitat;
  List<String> usuaris;

  Assignatura.fromRaw(Map<String, dynamic> data, String id) {
    this.id = id;
    nom = data['nom'];
    acronim = data['acronim'];
    tipus = data['tipus'];
    maxNumIntegrants = data['maxNumIntegrants'];
    grups = data['grups'];
    especialitat = data['especialitat'];
    if (data['usuaris'] != null)
      usuaris = List<String>.from(data['usuaris']);
    else
      usuaris = [];
  }

  List<String> get nomGrups => grups.keys.toList();
}

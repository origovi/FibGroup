class Usuari {
  String nom;
  String email;
  String descripcio;
  String photoUrl;
  List<Map<String, dynamic>> assignatures;

  Usuari.fromRaw(Map<String, dynamic> data) {
    nom = data['nom'] ?? "";
    email = data['email'];
    descripcio = data['descripcio'] ?? "";
    photoUrl = data['photoURL'] ?? "";
    if (data['assignatures'] != null)
      assignatures = List<Map<String, dynamic>>.from(data['assignatures']);
    else
      assignatures = [];
  }
}
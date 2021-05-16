import 'package:fibgroup/DataProvider.dart';
import 'package:fibgroup/DatabaseService.dart';
import 'package:fibgroup/models/Assignatura.dart';
import 'package:fibgroup/models/Grup.dart';
import 'package:fibgroup/models/Pair.dart';
import 'package:fibgroup/models/Usuari.dart';
import 'package:fibgroup/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageMissatges extends StatefulWidget {
  final List<Pair<String, Map<String, dynamic>>> invitacions;

  PageMissatges(this.invitacions);

  @override
  _PageMissatgesState createState() => _PageMissatgesState();
}

class _PageMissatgesState extends State<PageMissatges> {
  List<Assignatura> assignatures;
  List<Usuari> emisors;
  List<Pair<String, Map<String, dynamic>>> invitacions;

  void eliminaInvitacio(BuildContext context, String idInvitacio) {
    if (widget.invitacions.length == 1) {
      invitacions.removeWhere((element) => element.first == idInvitacio);
      Navigator.of(context).pop();
    } else {
      setState(() {
        invitacions.removeWhere((element) => element.first == idInvitacio);
      });
    }
  }

  @override
  void initState() {
    invitacions = widget.invitacions;
    assignatures = [];
    emisors = [];
    final provider = Provider.of<DataProvider>(context, listen: false);
    invitacions.forEach((element) {
      assignatures.add(provider.assigById(element.second['assigId']));
      emisors.add(provider.usuariByEmail(element.second['emisor']));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invitacions"),
      ),
      body: ListView.builder(
        itemCount: invitacions.length,
        itemBuilder: (context, index) {
          return Invitacio(
              assignatures[index],
              emisors[index],
              invitacions[index].second['missatge'],
              invitacions[index].first,
              Provider.of<DataProvider>(context, listen: false).grupDelMembre(
                  assignatures[index], invitacions[index].second['subgrup'], emisors[index]),
              eliminaInvitacio);
        },
      ),
    );
  }
}

class Invitacio extends StatelessWidget {
  final String missatge;
  final Usuari emisor;
  final Assignatura assig;
  final String idInvitacio;
  final Grup grup;
  final void Function(BuildContext, String) eliminaInvitacio;

  Invitacio(
      this.assig, this.emisor, this.missatge, this.idInvitacio, this.grup, this.eliminaInvitacio);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 15),
      child: NiceBox(
        child: Column(
          children: [
            Text(assig.nom),
            Text("Enviat per: " + emisor.nom),
            SizedBox(height: 15),
            Text(missatge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  tooltip: "Acceptar",
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    await Provider.of<DataProvider>(context, listen: false).afegirUsuariAGrup(grup.id);
                    eliminaInvitacio(context, idInvitacio);
                    await DatabaseService.eliminaInvitacio(idInvitacio);
                  },
                ),
                IconButton(
                  tooltip: "Rebutjar",
                  icon: Icon(Icons.clear),
                  onPressed: () async {
                    eliminaInvitacio(context, idInvitacio);
                    await DatabaseService.eliminaInvitacio(idInvitacio);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

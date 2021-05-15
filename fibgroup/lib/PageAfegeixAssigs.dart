import 'package:fibgroup/DataProvider.dart';
import 'package:fibgroup/SignInProvider.dart';
import 'package:fibgroup/models/Assignatura.dart';
import 'package:fibgroup/utils.dart';
import 'package:fibgroup/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageAfegeixAssigs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Afegeix Assignatures',
        ),
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Center(
            widthFactor: 40.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TriaTipus(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void mostraMenu(BuildContext context, Assignatura assig) {
  Popup.fancyPopup(
    context: context,
    columnCrossAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Selecciona un grup per a afegir-te",
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      Divider(
        thickness: 1.5,
      ),
      Container(
        height: 200,
        child: ListView.builder(
          itemCount: assig.nomGrups.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                    assig.nomGrups[index] + ((assig.nomGrups[index].endsWith('0')) ? "  (Teoria)" : "  (Lab)")),
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () {},
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                );
                await Provider.of<DataProvider>(context, listen: false).afegirAssig(assig, assig.nomGrups[index]);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text("Assignatura afegida"),
                ));
              },
            );
          },
        ),
      ),
      Center(
        child: TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text("Cancel"),
        ),
      ),
    ],
  );
}

class TriaTipus extends StatefulWidget {
  const TriaTipus({Key key}) : super(key: key);

  @override
  State<TriaTipus> createState() => _TriaTipusState();
}

class _TriaTipusState extends State<TriaTipus> {
  String _tipus;

  @override
  Widget build(BuildContext context) {
    List<Assignatura> assigs;
    if (_tipus != null) {
      assigs = Provider.of<DataProvider>(context, listen: false)
          .assignaturesPerTipus(_tipus.toLowerCase());
    } else
      assigs = [];
    return Column(
      children: [
        DropdownButton<String>(
          focusColor: Colors.white,
          value: _tipus,
          style: TextStyle(color: Colors.white),
          iconEnabledColor: Colors.black,
          items: <String>[
            'Comunes',
            'Especialitat',
            'Optatives',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text(
            "Escull una opció",
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          onChanged: (String value) {
            setState(() {
              _tipus = value;
            });
          },
        ),
        if (_tipus == 'Especialitat') TriaEspecialitat(),
        if (_tipus != 'Especialitat' && assigs.isNotEmpty) LlistaAssigs(assigs),
      ],
    );
  }
}

class TriaEspecialitat extends StatefulWidget {
  @override
  _TriaEspecialitatState createState() => _TriaEspecialitatState();
}

class _TriaEspecialitatState extends State<TriaEspecialitat> {
  String _especialitat;

  @override
  Widget build(BuildContext context) {
    List<Assignatura> assigs;
    if (_especialitat != null) {
      assigs = Provider.of<DataProvider>(context, listen: false)
          .assignaturesPerEspecialitat(_especialitat);
    } else
      assigs = [];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: DropdownButton<String>(
            focusColor: Colors.white,
            value: _especialitat,
            style: TextStyle(color: Colors.white),
            iconEnabledColor: Colors.black,
            items: <String>[
              'Computació',
              'Enginyeria del Software',
              'Enginyeria de Computadors',
              "Sistemes d'informació",
              "Tecnologies de la informació",
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            hint: Text(
              "Escull una especialitat",
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            onChanged: (String value) {
              setState(() {
                _especialitat = value;
              });
            },
          ),
        ),
        if (assigs.isNotEmpty) LlistaAssigs(assigs),
      ],
    );
  }
}

class LlistaAssigs extends StatelessWidget {
  final List<Assignatura> assigs;
  LlistaAssigs(this.assigs);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "  Assignatures",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Column(
          children: List.generate(
            assigs.length,
            (index) => Center(
              child: Container(
                padding: EdgeInsets.only(bottom: 15),
                width: double.infinity,
                child: NiceBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${assigs[index].nom} [${assigs[index].acronim}]",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Grups de ${assigs[index].maxNumIntegrants} persones",
                        style: TextStyle(fontSize: 12),
                      ),
                      if (assigs[index].grups != null && assigs[index].grups.isNotEmpty)
                        Column(
                          children: List.generate(
                            assigs[index].grups.length,
                            (index2) {
                              return Text(
                                "  " + assigs[index].grups.keys.elementAt(index2),
                                style: TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  onTap: () => mostraMenu(context, assigs[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

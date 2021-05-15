import 'package:fibgroup/DataProvider.dart';
import 'package:fibgroup/models/Assignatura.dart';
import 'package:fibgroup/models/Grup.dart';
import 'package:fibgroup/utils.dart';
import 'package:fibgroup/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageAssignatura extends StatelessWidget {
  final Assignatura assig;
  final String subgrup;

  PageAssignatura(Map<String, dynamic> data)
      : assig = data['assig'],
        subgrup = data['grup'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxScrolled) {
            return [
              SliverAppBar(
                  brightness: Brightness.dark,
                  title: Text(assig.nom),
                  floating: true,
                  pinned: true,
                  forceElevated: innerBoxScrolled,
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.list),
                      ),
                      Tab(
                        icon: Icon(Icons.group),
                      ),
                    ],
                  ))
            ];
          },
          body: TabBarView(
            children: [
              ScreenGrups(assig, subgrup),
              ScreenEstudiants(assig, subgrup),
            ],
          ),
        ),
      ),
    );
  }
}

class ScreenGrups extends StatelessWidget {
  final Assignatura assig;
  final String subgrup;
  ScreenGrups(this.assig, this.subgrup);

  void nouGrup(BuildContext context) {
    GlobalKey<FormState> key = GlobalKey<FormState>();
    TextEditingController nomController = TextEditingController();
    TextEditingController descripcioController = TextEditingController();
    FocusNode descripcioNode = FocusNode();
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

    Popup.fancyPopup(
      columnCrossAlignment: CrossAxisAlignment.start,
      context: context,
      children: [
        Text(
          "  Nou grup",
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        StatefulBuilder(builder: (contextSt, setStateSt) {
          Future<void> validate() async {
            if (key.currentState.validate()) {
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
              await Provider.of<DataProvider>(context, listen: false).creaGrup(
                  nom: nomController.text.trim(), descripcio: descripcioController.text.trim());
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              autovalidateMode = AutovalidateMode.always;
            }
          }

          return Form(
            key: key,
            autovalidateMode: autovalidateMode,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: nomController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  onFieldSubmitted: (_) => descripcioNode.requestFocus(),
                  validator: (value) {
                    if (value.trim().isNotEmpty) {
                      return null;
                    } else
                      return "Introdueix un nom vàlid";
                  },
                  decoration: InputDecoration(
                    //hintText: "This will be fixed for the person's lifetime",
                    //hintStyle: TextStyle(fontSize: 12),
                    labelText: "Nom del grup *",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    isDense: true,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 2,
                  controller: descripcioController,
                  focusNode: descripcioNode,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.trim().isNotEmpty) {
                      return null;
                    } else
                      return "Introdueix una descripció vàlida";
                  },
                  decoration: InputDecoration(
                    labelText: "Descripció *",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                  ),
                ),
                ElevatedButton(onPressed: validate, child: Text("Crea"))
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context, listen: false);
    var grups = provider.grupsAssig(this.assig, this.subgrup);
    Grup grupDelMembre = provider.grupDelMembre(assig, subgrup, provider.usuariActual);
    bool teGrup = grupDelMembre != null;
    return Scaffold(
      floatingActionButton: (!teGrup)
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => nouGrup(context),
            )
          : null,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          if (grups.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (teGrup)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "  El teu grup",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 10),
                        GrupTile(
                            grup: grupDelMembre, assig: assig, color: Colors.blue.withOpacity(0.2))
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    teGrup ? "  Altres grups" : "  Grups",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Column(
                  children: List.generate(
                    grups.length,
                    (index) {
                      if (grups[index].id == grupDelMembre.id) return SizedBox(height: 0);
                      return GrupTile(grup: grups[index], assig: assig);
                    },
                  ),
                )
              ],
            ),
          if (grups.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Text("No hi ha grups creats, pots crear un clickant al botó '+'"),
              ),
            )
        ],
      ),
    );
  }
}

class GrupTile extends StatelessWidget {
  const GrupTile({
    Key key,
    @required this.grup,
    @required this.assig,
    this.color = Colors.white,
  }) : super(key: key);

  final Grup grup;
  final Assignatura assig;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 15),
      child: NiceBox(
        color: this.color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(grup.nom, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            if (grup.descripcio != null && grup.descripcio.isNotEmpty)
              Text(
                grup.descripcio,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Membres  ${grup.membres.length} / ${assig.maxNumIntegrants}",
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: List.generate(
                      grup.membres.length,
                      (indexMember) => Text(
                        grup.membres[indexMember].nom,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenEstudiants extends StatelessWidget {
  final Assignatura assig;
  final String subgrup;
  ScreenEstudiants(this.assig, this.subgrup);
  @override
  Widget build(BuildContext context) {
    var membres = Provider.of<DataProvider>(context, listen: false).membresAssig(this.assig);
    print("LENNN" + membres.length.toString());
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          if (membres.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "  Membres",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Column(
                  children: List.generate(
                    membres.length,
                    (index) {
                      Grup grupDelMembre = Provider.of<DataProvider>(context, listen: false)
                          .grupDelMembre(assig, subgrup, membres[index]);
                      bool teGrup = grupDelMembre != null;
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 15),
                        child: NiceBox(
                          color: (!teGrup) ? Colors.white : Colors.grey[500],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(membres[index].nom,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                  if (membres[index].descripcio != null &&
                                      membres[index].descripcio.isNotEmpty)
                                    Text(
                                      membres[index].descripcio,
                                      style: TextStyle(
                                          color: Colors.grey[700], fontStyle: FontStyle.italic),
                                    ),
                                  if (teGrup)
                                    Row(
                                      children: [
                                        Text(
                                          "Grup: ",
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
                                        Text(grupDelMembre.nom),
                                      ],
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Disponible"),
                                  Checkbox(
                                    value: !teGrup,
                                    onChanged: (_) {},
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
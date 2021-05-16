import 'package:fibgroup/DataProvider.dart';
import 'package:fibgroup/PageAfegeixAssigs.dart';
import 'package:fibgroup/PageAssignatura.dart';
import 'package:fibgroup/widgets/NiceBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageMevesAssigs extends StatefulWidget {
  PageMevesAssigs();

  @override
  _PageMevesAssigsState createState() => _PageMevesAssigsState();
}

class _PageMevesAssigsState extends State<PageMevesAssigs> {
  @override
  Widget build(BuildContext context) {
    var mevesAssigs = Provider.of<DataProvider>(context, listen: false).mevesAssigs();
    return Scaffold(
      appBar: AppBar(
        title: Text("Les meves assignatures"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PageAfegeixAssigs()))
            .then((value) => setState(() {})),
      ),
      body: Visibility(
        visible: mevesAssigs.isNotEmpty,
        replacement: Padding(
            padding: EdgeInsets.only(bottom: 200),
            child: Center(child: Text("No has afegit cap assignatura, clicka al botó  '+'"))),
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: mevesAssigs.length,
          itemBuilder: (context, index) => Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 15),
              width: double.infinity,
              child: NiceBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${mevesAssigs[index]['assig'].nom} [${mevesAssigs[index]['assig'].acronim}]",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (mevesAssigs[index]['assig'].grups != null &&
                        mevesAssigs[index]['assig'].grups.isNotEmpty)
                      Column(
                        children: List.generate(
                          mevesAssigs[index]['assig'].grups.length,
                          (index2) {
                            return Text(
                              "  " + mevesAssigs[index]['assig'].grups.keys.elementAt(index2),
                              style: TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => PageAssignatura(mevesAssigs[index]))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

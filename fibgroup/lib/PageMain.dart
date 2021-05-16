import 'package:fibgroup/DataProvider.dart';
import 'package:fibgroup/PageAfegeixAssigs.dart';
import 'package:fibgroup/PageMevesAssigs.dart';
import 'package:fibgroup/PageMissatges.dart';
import 'package:fibgroup/SignInProvider.dart';
import 'package:fibgroup/models/Pair.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageMain extends StatelessWidget {
  final User user;
  final List<Pair<String, Map<String, dynamic>>> invitacions;

  PageMain({@required this.user, @required this.invitacions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: Provider.of<DataProvider>(context, listen: false).refresh,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Hola, ${user.displayName}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(1.0),
                      height: 2,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.wavy,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: FlatButton(
                    color: Colors.blue,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PageMevesAssigs()),
                    ),
                    child: Text("Les meves assignatures"),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: FlatButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PageAfegeixAssigs()),
                    ),
                    color: Colors.blue,
                    child: Text("Afegeix assignatures"),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: FlatButton(
                    color: Colors.red,
                    onPressed: (this.invitacions.isNotEmpty)
                        ? () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => PageMissatges(this.invitacions)),
                            )
                        : null,
                    child: Text("Invitacions de grup"),
                  ),
                ),
                SizedBox(height: 70),
                Center(
                  child: FlatButton(
                    color: Colors.blue,
                    onPressed: Provider.of<SignInProvider>(context, listen: false).logout,
                    child: Text("Tanca sessió"),
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

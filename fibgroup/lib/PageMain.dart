import 'package:fibgroup/PageAfegeixAssigs.dart';
import 'package:fibgroup/PageMevesAssigs.dart';
import 'package:fibgroup/SignInProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageMain extends StatelessWidget {
  final User user;

  PageMain({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  'Hola ${user.displayName}',
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: FlatButton(
                    color: Colors.red,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PageMevesAssigs()),
                    ),
                    child: Text("Les meves assignatures"),
                  ),
                ),
                Center(
                  child: FlatButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PageAfegeixAssigs()),
                    ),
                    color: Colors.red,
                    child: Text("Afegeix assignatures"),
                  ),
                ),
                Center(
                  child: FlatButton(
                    color: Colors.red,
                    // onPressed: () => Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => PageMissatges()),
                    // ),
                    child: Text("Missatges de grup"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: FlatButton(
                    color: Colors.red,
                    onPressed: Provider.of<SignInProvider>(context, listen: false).logout,
                    child: Text("Tanca sessió"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

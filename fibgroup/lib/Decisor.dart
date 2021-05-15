import 'package:fibgroup/DataProvider.dart';
import 'package:fibgroup/PageLogin.dart';
import 'package:fibgroup/PageMain.dart';
import 'package:fibgroup/SignInProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Decisor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User> userSnapshot) {
          final signInProvider = Provider.of<SignInProvider>(context);
          if (signInProvider.isSigningIn)
            return PageLogin(true);
          // if the user has successfully signed in
          else if (userSnapshot.hasData) {
            Provider.of<DataProvider>(context, listen: false).init(userSnapshot.data.email);
            return FutureBuilder(
              future: Provider.of<DataProvider>(context, listen: false).refresh(),
              builder: (context, refreshSnapshot) {
                if (refreshSnapshot.hasData) {
                  return PageMain(user: userSnapshot.data);
                }
                else return PageLogin(true);
              },
            );
          } else {
            return PageLogin(false);
          }
        });
  }
}

import 'package:fibgroup/SignInProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageLogin extends StatelessWidget {
  final bool loading;

  PageLogin(this.loading);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Identifica't si us plau"),
      ),
      body: Center(child: loading ? CircularProgressIndicator() : _LoginButton(context)),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final BuildContext contextPare;

  _LoginButton(this.contextPare);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        var hasAccess = await Provider.of<SignInProvider>(context, listen: false).login();
        if (!hasAccess) {
          showDialog(
            context: contextPare,
            builder: (_) => AlertDialog(
              title: Text("Alerta!"),
              content: Text("No pertanys a upc.edu"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(contextPare).pop(),
                  child: Text("Tanca"),
                )
              ],
            ),
            barrierDismissible: false,
          );
        }
      },
      child: Text("Login amb Google"),
    );
  }
}

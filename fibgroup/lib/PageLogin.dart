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
        title: Text("Please log in"),
      ),
      body: Center(child: loading ? CircularProgressIndicator() : _LoginButton()),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        var hasAccess = await Provider.of<SignInProvider>(context, listen: false).login();
        if (!hasAccess) {
         print("guarro");
          // showDialog(
          //   context: context,
          //   builder: (_) => AlertDialog(
          //     title: Text("Alerta!"),
          //     content: Text("No pertanys a upc.edu, guarro"),
          //     actions: <Widget>[
          //       TextButton(
          //         onPressed: () => Navigator.of(context).pop(),
          //         child: Text("Tanca"),
          //       )
          //     ],
          //   ),
          //   barrierDismissible: false,
          // );
        }
      },
      child: Text("Login amb Google"),
    );
  }
}

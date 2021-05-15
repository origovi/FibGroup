import 'package:fibgroup/DataProvider.dart';
import 'package:fibgroup/Decisor.dart';
import 'package:fibgroup/SignInProvider.dart';
import 'package:fibgroup/PageMain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<SignInProvider>(
                create: (context) => SignInProvider(context),
              ),
              ChangeNotifierProvider<DataProvider>(
                create: (context) => DataProvider(context),
              ),
            ],
            child: MaterialApp(
              title: 'FibGroup',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: Decisor(),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

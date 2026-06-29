import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:places/login/pages/login_page.dart';

void main() {

  // PARTE AÑADIDA POR EL REPOSITORIO "THEGORGEOUSLOGIN" PARA LA ORIENTACIÓN DE LA APP
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Places",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: LoginPage(),
    );
  }
}

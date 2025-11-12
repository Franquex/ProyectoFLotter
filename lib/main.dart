import 'package:flutter/material.dart';
import 'package:widget_stack/places_cupertino.dart';

import 'home.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Places",
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: PlacesCupertino(),
    );
  }
}
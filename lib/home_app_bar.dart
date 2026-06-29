import 'package:flutter/material.dart';
import 'package:places/card_image.dart';
import 'package:places/gradient_back.dart';

import 'card_image_list.dart';

class HomeAppBar extends StatelessWidget{

  String textoTitulo;

  HomeAppBar(this.textoTitulo);

  @override
  Widget build(BuildContext context) {


    final titulo = Container(
      margin: EdgeInsets.only(
        top: 40,
        left: 30
      ),
      child: Text(
        textoTitulo,
        style: TextStyle(
          fontFamily: "Lato",
          fontWeight: FontWeight.w900,
          fontSize: 30,
          color: const Color(0xFFFFFFFF)
        ),
      ),
    );

    final appBar = Stack(
      children: <Widget>[
        GradientBack(),
        titulo,
        CardImageList()
      ],
    );

    return appBar;
  }
}
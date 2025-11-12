import 'package:flutter/material.dart';
import 'package:widget_stack/card_image_list.dart';
import 'package:widget_stack/gradient_back.dart';
import 'package:widget_stack/card_image.dart';

class HomeAppBar extends StatelessWidget{
  @override

  String textoTitulo;
  HomeAppBar(this.textoTitulo);


  Widget build(BuildContext context) {
    //
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
          color: Colors.white
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
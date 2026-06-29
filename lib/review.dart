import 'package:flutter/material.dart';

class Review extends StatelessWidget {

  String pathPhoto;
  String textNombreUsuario;
  String textoResumenUsuario;
  int cantidadEstrellas;
  String textoComentario;

  Review(this.pathPhoto, this.textNombreUsuario, this.textoResumenUsuario, this.cantidadEstrellas, this.textoComentario);

  @override
  Widget build(BuildContext context){

    final foto = Container(
      margin: EdgeInsets.only(
        right: 10,
        top: 10,
      ),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(
            pathPhoto
          ),
          fit: BoxFit.cover
        )
      ),
    );

    final nombreUsuario = Container(
      child: Text(
        textNombreUsuario,
        style: TextStyle(
          fontFamily: "Lato",
          fontSize: 22
        ),
      ),
    );

    final resumenUsuario = Container(
      margin: EdgeInsets.only(
        right: 10,
      ),
      child: Text(
        textoResumenUsuario,
        style: TextStyle(
          fontFamily: "Lato",
          color: Colors.black54
        ),
      ),
    );

    final estrella = Container(
      margin: EdgeInsets.only(
          right: 5
      ),
      child: Icon(
        Icons.star,
        color: Colors.amber,
        size: 18,
      ),
    );

    final estrellaBorde = Container(
      margin: EdgeInsets.only(
          right: 5
      ),
      child: Icon(
        Icons.star_border,
        color: Colors.black54,
        size: 18,
      ),
    );

    List<Container> estrellas = [];
    for(int i = 0; i < 5; i++){
      if(i < cantidadEstrellas){
        estrellas.add(estrella);
      }else{
        estrellas.add(estrellaBorde);
      }
    }


    final filaEstrellas = Row(
      children: estrellas,
    );

    final filaResumen = Row(
      children: <Widget>[
        resumenUsuario,
        filaEstrellas
      ],
    );

    final comentario = Container(
      child: Text(
        textoComentario,
          style: TextStyle(
          fontFamily: "Lato",
      ),
      ),
    );

    final columnaReview = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        nombreUsuario,
        filaResumen,
        comentario
      ],
    );

    final review = Row(
      children: <Widget>[
        foto,
        columnaReview
      ],
    );
    return review;
  }
}
import 'package:flutter/cupertino.dart';
import 'package:places/review.dart';

class ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reviewList = Column(
        children: <Widget>[
          Review("assets/images/persona1.png", "Lidia Gueiler", "1 reviews - 3 photos", 2, "Mediocre! No vuelvo! D:"),
          Review("assets/images/persona2.jpg", "Maria Eugenia", "4 reviews - 2 photos", 4, "Nunca fui a ese lugar... :D"),
          Review("assets/images/persona3.jpg", "Lorena", "3 reviews - 2 photos", 5, "Bastante recomendable..."),
          Review("assets/images/persona4.jpg", "Luis", "8 reviews - 4 photos", 2, "Que lugar mas basura! jamas volveré!"),
          Review("assets/images/persona5.jpg", "Carlos", "3 reviews - 4 photos", 3, "Bastante interesante :D!"),
        ]
    );

    return reviewList;
  }
}

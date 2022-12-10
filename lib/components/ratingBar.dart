import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:secret_note/note.dart';

class Star extends StatelessWidget {
  const Star({super.key, this.chageRating});
  final chageRating;
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      glowRadius: 0.1,
      glowColor: Colors.amber[300],
      initialRating: 2.5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 35,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber[600],
      ),
      onRatingUpdate: (star) {
        chageRating(star);
      },
    );
  }
}

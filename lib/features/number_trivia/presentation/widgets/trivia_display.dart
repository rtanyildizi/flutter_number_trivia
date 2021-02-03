import '../../domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia trivia;

  const TriviaDisplay({
    Key key,
    @required this.trivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          trivia.number.toString(),
          style: const TextStyle(
            color: triviaPurple,
            fontFamily: 'Khula',
            fontSize: 24,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  trivia.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'MartelSans',
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

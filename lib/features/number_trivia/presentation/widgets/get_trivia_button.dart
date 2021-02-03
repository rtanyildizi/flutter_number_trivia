import 'package:flutter/material.dart';

class GetTriviaButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final LinearGradient gradient;
  const GetTriviaButton({
    Key key,
    @required this.onPressed,
    this.text,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RaisedButton(
        splashColor: Colors.white24,
        onPressed: onPressed,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 40.0,
            ), // min sizes for Material buttons
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Khula',
                color: triviaPurple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

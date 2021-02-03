import 'package:flutter/material.dart';

class LoadingDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
            Color(0xFF8C008C),
          ),
        ),
      ),
    );
  }
}

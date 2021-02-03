import 'package:flutter/material.dart';

class ShowCase extends StatelessWidget {
  final Widget child;
  const ShowCase({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10.0),
      elevation: 6.0,
      shadowColor: Colors.grey[200],
      child: SizedBox(
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const Image(
                fit: BoxFit.fitHeight,
                image: witchHazeMeshGradientImage,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

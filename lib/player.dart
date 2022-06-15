import 'package:flutter/material.dart';

class MyPLayer extends StatelessWidget {
  final double playerX;
  const MyPLayer({
    Key? key, required this.playerX,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.deepPurple,
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}

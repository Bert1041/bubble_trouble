import 'package:flutter/material.dart';

class MyMissile extends StatelessWidget {
  final double missileX;
  final double missileHeight;

  const MyMissile({
    Key? key, required this.missileX, required this.missileHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missileX, 1),
      child: Container(
        width: 2,
        height: missileHeight,
        color: Colors.grey,
      ),
    );
  }
}
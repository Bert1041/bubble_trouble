import 'package:flutter/material.dart';

class DirectionButton extends StatelessWidget {
  final IconData icon;
  final Function function;
  const DirectionButton({Key? key, required this.icon, required this.function}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: GestureDetector(
        onTap: () => function(),
        child: Container(
          color: Colors.grey[100],
          //width: 80,
          height: 100,
          child: Center(
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double bx;
  final double by;

  MyBall({required this.bx,required this.by});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(bx, by),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.brown,
        ),
      ),
    );
  }
}
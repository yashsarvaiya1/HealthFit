import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final x;

  MyPlayer({this.x});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.deepPurple,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}

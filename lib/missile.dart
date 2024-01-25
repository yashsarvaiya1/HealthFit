import 'package:flutter/material.dart';

class MyMissile extends StatelessWidget {
  final mx;
  final mh;

  MyMissile({this.mx,this.mh});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(mx, 1),
      child: Container(
        width: 2,
        height: mh,
        color: Colors.grey,
      ),
    );
  }
}

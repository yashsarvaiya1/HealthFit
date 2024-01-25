import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ballcatch/ball.dart';
import 'package:ballcatch/button.dart';
import 'package:ballcatch/missile.dart';
import 'package:ballcatch/player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  late AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  static double x = 0;
  double mx = x, mh = 10;
  bool midShot = false;
  static int sign = Random().nextInt(1);
  static double bx = Random().nextDouble(), by = Random().nextDouble();
  static var bd = Random().nextInt(1);

  @override
  void initState() {
    super.initState();
    randomBall();
    assetsAudioPlayer.open(
      Audio("audio/vamp_back.mp3"),
      loopMode: LoopMode.single,
      autoStart: false,
    );
  }

  bool playerDies() {
    if ((bx - x).abs() < 0.05 && by > 0.85) {
      return true;
    } else {
      return false;
    }
  }

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 70;

    assetsAudioPlayer.play();
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = -6 * time * time + velocity * time;

      if (height <= 0) {
        time = 0;
      }

      time += 0.1;

      setState(() {
        by = heightToPosition(height);
      });

      if (bx - 0.005 < -1) {
        bd = 1;
      } else if (bx + 0.005 > 1) {
        bd = 0;
      }

      if (bd == 0) {
        setState(() {
          bx -= 0.005;
        });
      } else if (bd == 1) {
        setState(() {
          bx += 0.005;
        });
      }

      if (playerDies()) {
        timer.cancel();
        _showDialog();
        randomBall();
        assetsAudioPlayer.pause();
      }
    });
  }

  static void randomBall() {
    bd = Random().nextInt(1);
    if(bd==1) {
      bd=0;
    } else {
      bd=1;
    }
    if (sign == 0) {
      bx = -(Random().nextDouble());
      by = Random().nextDouble();
    }
    else{
      bx = Random().nextDouble();
      by = Random().nextDouble();
    }
  }

  void _showDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Game Over !!"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Try Again..")),
              ]);
        });
  }

  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void moveLeft() {
    setState(() {
      if (x - 0.1 > -1) {
        x -= 0.1;
      }
      if (!midShot) {
        mx = x;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (x + 0.1 < 1) {
        x += 0.1;
      }
      if (!midShot) {
        mx = x;
      }
    });
  }

  void fireMissile() {
    if (!midShot) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        midShot = true;

        setState(() {
          mh += 10;
        });
        if (mh > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }

        if (by > heightToPosition(mh) && (bx - mx).abs() < 0.05) {
          resetMissile();
          randomBall();
          timer.cancel();
        }
      });
    }
  }

  void resetMissile() {
    midShot = false;
    mx = x;
    mh = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              color: Colors.deepPurple[200],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(bx: bx, by: by),
                    MyMissile(
                      mx: mx,
                      mh: mh,
                    ),
                    MyPlayer(
                      x: x,
                    ),
                  ],
                ),
              ),
            )),
        Expanded(
            child: Container(
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyButton(
                icon: Icons.play_arrow,
                function: startGame,
              ),
              MyButton(
                icon: Icons.arrow_back,
                function: moveLeft,
              ),
              MyButton(
                icon: Icons.arrow_upward,
                function: fireMissile,
              ),
              MyButton(
                icon: Icons.arrow_forward,
                function: moveRight,
              ),
            ],
          ),
        ))
      ],
    );
  }
}

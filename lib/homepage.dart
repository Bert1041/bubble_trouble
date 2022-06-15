import 'dart:async';

import 'package:bubble_trouble/player.dart';
import 'package:flutter/material.dart';

import 'ball.dart';
import 'button.dart';
import 'missile.dart';

enum Direction { left, right }

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

// player variables
double playerX = 0;

// missile variables
double missileX = playerX;
// double missileY = 1;
double missileHeight = 10;
bool midShot = false;

// ball variables
double ballX = 0.5;
double ballY = 1;
var ballDirection = Direction.left;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  startGame();
                },
                child: const Icon(Icons.play_circle),
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[200],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(ballX: ballX, ballY: ballY),
                    MyMissile(
                      missileHeight: missileHeight,
                      missileX: missileX,
                    ),
                    MyPLayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DirectionButton(
                      icon: Icons.arrow_back_ios,
                      function: () {
                        moveLeft();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: DirectionButton(
                      icon: Icons.keyboard_double_arrow_up,
                      function: () {
                        fireMissile();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: DirectionButton(
                      icon: Icons.arrow_forward_ios,
                      function: () {
                        moveRight();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void moveLeft() {
    missileX = playerX;
    setState(() {
      if (playerX - 0.1 < -1) {
        // do nothing
      } else {
        playerX -= 0.1;
      }

      // only make the X coordinate the same when it isn't in the middle of a shot
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        // shots fired
        midShot = true;

        // missile grows til it hits the top of the screen
        setState(() {
          missileHeight += 10;
        });

        //stop missile when it reaches top of screen
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }

        // check if missile has hit the ball
        if (ballY > heightToCoordinate(missileHeight) &&
            (ballX - missileX).abs() < 0.03) {
          resetMissile();
          ballY = 5;
          timer.cancel();
        }
      });
    }
  }

  void moveRight() {
    setState(() {
      missileX = playerX;
      if (playerX + 0.1 > 1) {
        // do nothing
      } else {
        playerX += 0.1;
      }

      // only make the X coordinate the same when it isn't in the middle of a shot
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void startGame() {
    print('start');
    double time = 0;
    double height = 0;
    double velocity = 60; // how strong the jump is

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // quadratic equation that models a bounce (upside down parabola)
      height = -1.2 * time * time + velocity * time;

      // if the ball reaches the ground, reset the jump
      if (height < 0) {
        time = 0;
      }

      setState(() {
        ballY = heightToCoordinate(height);
      });

      // if the ball hits the left wall, then change direction to right
      if (ballX - 0.005 < -1) {
        ballDirection = Direction.right;
        // if the ball hits the right wall, then change direction to left
      } else if (ballX + 0.005 > 1) {
        ballDirection = Direction.left;
      }
      // move the ball in the correct direction
      if (ballDirection == Direction.left) {
        setState(() {
          ballX -= 0.005;
        });
      } else if (ballDirection == Direction.right) {
        setState(() {
          ballX += 0.005;
        });
      }

      // check if the ball hits the player
      if (playerDies()) {
        timer.cancel();
        _showDialog();
        // print('dead');
      }

      // keep the time going!
      time += 0.1;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            backgroundColor: Colors.grey,
            title: Text(
              "you dead bro",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  // converts height to a  coordinate
  double heightToCoordinate(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 0;
    midShot = false;
  }

  bool playerDies() {
    // if the ball position and the player position
    // are the same then  player dies
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }
}

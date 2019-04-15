import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: RadialMenu()),
      ),
    );
  }
}

class RadialMenu extends StatefulWidget {
  createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(controller: controller);
  }
}

class RadialAnimation extends StatelessWidget {
  RadialAnimation({Key key, this.controller})
      : scale = Tween<double>(
          begin: 1.5,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        translation = Tween<double>(begin: 0.0, end: 100.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.linear),
        ),
        rotation = Tween<double>(begin: 0.0, end: 360.0).animate(
          CurvedAnimation(
              parent: controller,
              curve: Interval(
                0.0,
                1,
              )),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;

  build(context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, builder) {
          return Transform.rotate(
              angle: radians(rotation.value),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildButton(0,
                      color: Colors.red, icon: FontAwesomeIcons.thumbtack),
                  _buildButton(45,
                      color: Colors.orange, icon: FontAwesomeIcons.sprayCan),
                  _buildButton(90,
                      color: Colors.blue, icon: FontAwesomeIcons.fire),
                  _buildButton(135,
                      color: Colors.black, icon: FontAwesomeIcons.kiwiBird),
                  _buildButton(180,
                      color: Colors.indigo, icon: FontAwesomeIcons.cat),
                  _buildButton(225,
                      color: Colors.pink, icon: FontAwesomeIcons.paw),
                  _buildButton(270,
                      color: Colors.yellow, icon: FontAwesomeIcons.bong),
                  _buildButton(315,
                      color: Colors.green, icon: FontAwesomeIcons.bolt),
                  Transform.scale(
                    scale: scale.value -
                        1.5, // subtract the beginning value to run the opposite animation
                    child: FloatingActionButton(
                        child: Icon(FontAwesomeIcons.timesCircle),
                        onPressed: _close,
                        backgroundColor: Colors.red),
                  ),
                  Transform.scale(
                    scale: scale.value,
                    child: FloatingActionButton(
                        child: Icon(FontAwesomeIcons.solidDotCircle),
                        onPressed: _open),
                  )
                ],
              ));
        });
  }

  _buildButton(double angle, {Color color, IconData icon}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
            (translation.value) * cos(rad), (translation.value) * sin(rad)),
      child: FloatingActionButton(
        child: Icon(icon),
        backgroundColor: color,
        onPressed: _close,
      ),
    );
  }

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }
}

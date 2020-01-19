import 'package:analog_clock/my_flutter_app_icons.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class AnimatedWether extends AnimatedWidget {
//   // Make the Tweens static because they don't change.
//   AnimatedWether({Key key, Animation<double> animation})
//       : super(key: key, listenable: animation);

// }

class Wether extends StatefulWidget {
  const Wether(this.condition);
  final String condition;

  @override
  _WetherState createState() => _WetherState();
}

class _WetherState extends State<Wether> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  var wetherIcon = MyFlutterApp.sun;
  var wetherString = "Default";

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0.6, end: 1.0).animate(controller)
      // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
    _updateModel();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Container(
        alignment: Alignment.centerLeft,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ScaleTransition(
                scale: animation,
                child:
                    Icon(wetherIcon, size: _width * 0.12, color: Colors.white),
              ),
              // Text(wetherString,
              //     style: GoogleFonts.dosis(
              //         textStyle: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: _width * 0.06,
              //             color: Colors.white))),
            ]));
  }

  void didUpdateWidget(Wether oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.condition != oldWidget.condition) {
      _updateModel();
    }
  }

  void _updateModel() {
    setState(() {
      wetherString = widget.condition;
      if (widget.condition == "sunny") {
        wetherIcon = MyFlutterApp.sun;
      } else if (widget.condition == "windy") {
        wetherIcon = MyFlutterApp.windy;
      } else if (widget.condition == 'cloudy' || widget.condition == 'foggy') {
        wetherIcon = MyFlutterApp.cloud;
      } else if (widget.condition == 'rainy') {
        wetherIcon = MyFlutterApp.rain;
      } else if (widget.condition == 'thunderstorm') {
        wetherIcon = MyFlutterApp.cloud_flash;
      } else if (widget.condition == 'snowy') {
        wetherIcon = MyFlutterApp.snow;
      }

      // Cause the clock to rebuild when the model changes.
    });
  }
  // @override
  // Widget build(BuildContext context) => AnimatedWether(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

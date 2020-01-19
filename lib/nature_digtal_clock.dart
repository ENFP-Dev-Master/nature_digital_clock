import 'dart:async';
import 'dart:ui';
import 'package:align_positioned/align_positioned.dart';
import 'package:analog_clock/wether.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);
  final ClockModel model;
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  VideoPlayerController _controller;
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  var _prev_condition = '';

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      if (_condition == "" || _condition != widget.model.weatherString) {
        _condition = widget.model.weatherString;
        var assetName = '';
        if (_condition == "sunny") {
          assetName = 'assets/video/video_sunny.mp4';
        } else if (_condition == "windy") {
          assetName = 'assets/video/video_sunny.mp4';
        } else if (_condition == 'cloudy' || _condition == 'foggy') {
          assetName = 'assets/video/video_cloudy.mp4';
        } else if (_condition == 'rainy') {
          assetName = 'assets/video/video_rainy.mp4';
        } else if (_condition == 'thunderstorm') {
          assetName = 'assets/video/video_rainy.mp4';
        } else if (_condition == 'snowy') {
          assetName = 'assets/video/video_snowy.mp4';
        }
        _controller = VideoPlayerController.asset(assetName)
          ..initialize().then((_) {
            _controller.play();
            _controller.setLooping(true);
            setState(() {});
          });
      }
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    var _hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    var _minute = DateFormat('mm').format(_dateTime);
    var _second = DateFormat('ss').format(_dateTime);
    final _width = MediaQuery.of(context).size.width;
    return Container(
        child: Center(
            child: Stack(children: <Widget>[
      SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size?.width ?? 0,
            height: _controller.value.size?.height ?? 0,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
      AlignPositioned(
          alignment: Alignment.center,
          child: Container(
              height: _width * 0.4,
              width: _width * 0.4,
              decoration: BoxDecoration(
                color: Color.fromARGB(72, 0, 0, 0),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Wether(_condition),
                    Container(
                      // alignment: Alignment.center,
                      child: Text(_hour + " : " + _minute + " : " + _second,
                          style: GoogleFonts.dosis(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _width * 0.07,
                                  color: Colors.white))),
                    ),
                  ])))
    ])));
  }
}

// Automatic FlutterFlow imports
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class RectSlider extends StatefulWidget {
  const RectSlider({
    super.key,
    this.width,
    this.height,
    required this.conncetion,
  });

  final double? width;
  final double? height;
  final BluetoothConnection? conncetion;

  @override
  State<RectSlider> createState() => _RectSliderState();
}

class _RectSliderState extends State<RectSlider> {
  int _currentSliderValue = 5;
  String toPass = '5';
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        // Thumb
        thumbColor: Color.fromARGB(255, 251, 178, 135),
        overlayColor: Colors.transparent,
        valueIndicatorColor: Colors.transparent,
        valueIndicatorTextStyle: TextStyle(
          color: Color(0xffcdd6f4),
        ),
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 20,
        ),
        // Track
        trackHeight: 15,
        activeTrackColor: Color.fromARGB(255, 251, 178, 135),
        inactiveTrackColor: Color.fromARGB(255, 248, 225, 177),
        // misc
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child: Slider(
        value: _currentSliderValue.toDouble(),
        min: 0,
        max: 10,
        divisions: 10,
        label: (_currentSliderValue + 1).toString().replaceAll("11", "FULL"),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value.toInt();

            if (value.toInt() == 10) {
              toPass = 'q';
            } else {
              toPass = value.toInt().toString();
            }
            widget.conncetion?.output.add(ascii.encode(toPass));
          });
        },
      ),
    );
  }
}

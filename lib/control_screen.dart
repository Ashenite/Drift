import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:drift/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

Flavor flavor = catppuccin.mocha;

class ControlScreen extends StatefulWidget {
  const ControlScreen(
      {super.key,
      required this.address,
      required this.name,
      required this.teamname,
      required this.img});

  final String address;
  final String name;
  final String teamname;
  final Uint8List img;

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  BluetoothConnection? connection;
  bool isConnected = false;

  bool forward = false;
  bool backward = false;
  bool left = false;
  bool right = false;
  bool headlights = false;
  bool backLights = false;
  Timer? signalSender;
  Timer? statusChecker;

  void _checkStatus() {
    statusChecker = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      isConnected = !isConnected;
      setState(() {});
    });
  }

  void _sendSignals() {
    signalSender = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (connection == null) {
        return;
      }
      if (connection?.isConnected == false) {
        signalSender?.cancel();
        Navigator.pop(context, 'Device disconnected');
        return;
      }
      // if everything is false, stop the car
      if (!forward && !backward && !left && !right) {
        connection?.output.add(ascii.encode('S'));
      }
      // now we have to consider combined logics, before singles, otherwise we might skip some signals
      else if (backward && right) {
        connection?.output.add(ascii.encode('J'));
      } else if (backward && left) {
        connection?.output.add(ascii.encode('H'));
      } else if (forward && right) {
        connection?.output.add(ascii.encode('I'));
      } else if (forward && left) {
        connection?.output.add(ascii.encode('G'));
      } else if (forward) {
        connection?.output.add(ascii.encode('F'));
      } else if (backward) {
        connection?.output.add(ascii.encode('B'));
      } else if (right) {
        connection?.output.add(ascii.encode('R'));
      } else if (left) {
        connection?.output.add(ascii.encode('L'));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkStatus();
    BluetoothConnection.toAddress(widget.address).then((conn) {
      connection = conn;
      setState(() {
        isConnected = true;
        statusChecker?.cancel();
      });
    }).catchError((error) {
      print("Special Error: $error");
      Navigator.pop(context,
          "Error while connecting. Try: restarting device, app, or bluetooth.");
    }).then((_) {
      _sendSignals();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // connection?.close().then((_) {
    connection?.dispose();
    // });
    signalSender?.cancel();
    statusChecker?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.asset(
                        'assets/appbar.png',
                      ).image,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.memory(
                                widget.img,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Stack(
                                      children: [
                                        Text(
                                          widget.teamname,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 2
                                              ..color = flavor.base,
                                          ),
                                        ),
                                        Text(
                                          widget.teamname,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Stack(
                                      children: [
                                        Text(
                                          'Device:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 1
                                              ..color = flavor.base,
                                          ),
                                        ),
                                        const Text(
                                          'Device:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 5),
                                    Stack(
                                      children: [
                                        Text(
                                          widget.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 1
                                              ..color = flavor.base,
                                          ),
                                        ),
                                        Text(
                                          widget.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(1, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 20, 32, 0),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: Color(0xFFCDD6F4),
                              shape: BoxShape.circle,
                            ),
                            alignment: const AlignmentDirectional(0, 0),
                            child: Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: isConnected
                                      ? const Color(0xffa6e3a1)
                                      : const Color(0xfff38ba8),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            height: 100,
                            child: RectSlider(
                              width: 300,
                              height: 100,
                              conncetion: connection,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: headlights
                                    ? const Color(0xff45475a)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    headlights
                                        ? 'assets/headlight_act.png'
                                        : 'assets/headlight.png',
                                    width: MediaQuery.sizeOf(context).width,
                                    height:
                                        MediaQuery.sizeOf(context).height * 1,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              headlights = !headlights;
                              connection?.output
                                  .add(ascii.encode(headlights ? 'W' : 'w'));
                              setState(() {});
                            },
                          ),
                          const SizedBox(width: 35),
                          GestureDetector(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: backLights
                                    ? const Color(0xff45475a)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    backLights
                                        ? 'assets/headlight_rev_act.png'
                                        : 'assets/headlight_rev.png',
                                    width: 300,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              backLights = !backLights;
                              connection?.output
                                  .add(ascii.encode(backLights ? 'U' : 'u'));
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 1),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Forward
                                    Transform.rotate(
                                      angle: 0,
                                      child: GestureDetector(
                                        child: Image.asset(
                                          forward
                                              ? 'assets/arrow_act.png'
                                              : 'assets/arrow_deact.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        onTapDown: (_) {
                                          forward = backward ? false : true;
                                          setState(() {});
                                        },
                                        onTapUp: (_) {
                                          forward = false;
                                          setState(() {});
                                        },
                                        onPanEnd: (_) {
                                          forward = false;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Left
                                    Transform.rotate(
                                      angle: -1.5708,
                                      child: GestureDetector(
                                        child: Image.asset(
                                          left
                                              ? 'assets/arrow_act.png'
                                              : 'assets/arrow_deact.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        onTapDown: (_) {
                                          left = right ? false : true;
                                          setState(() {});
                                        },
                                        onTapUp: (_) {
                                          left = false;
                                          setState(() {});
                                        },
                                        onPanEnd: (_) {
                                          left = false;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 100),
                                    // Right
                                    Transform.rotate(
                                      angle: 1.5708,
                                      child: GestureDetector(
                                        child: Image.asset(
                                          right
                                              ? 'assets/arrow_act.png'
                                              : 'assets/arrow_deact.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        onTapDown: (_) {
                                          right = left ? false : true;
                                          setState(() {});
                                        },
                                        onTapUp: (_) {
                                          right = false;
                                          setState(() {});
                                        },
                                        onPanEnd: (_) {
                                          right = false;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Backward
                                    Transform.rotate(
                                      angle: 3.1416,
                                      child: GestureDetector(
                                        child: Image.asset(
                                          backward
                                              ? 'assets/arrow_act.png'
                                              : 'assets/arrow_deact.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        onTapDown: (_) {
                                          backward = forward ? false : true;
                                          setState(() {});
                                        },
                                        onTapUp: (_) {
                                          backward = false;
                                          setState(() {});
                                        },
                                        onPanEnd: (_) {
                                          backward = false;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

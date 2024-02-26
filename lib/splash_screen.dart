import 'dart:io';

import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:drift/devices_screen.dart';
import 'package:drift/setup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Flavor flavor = catppuccin.mocha;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<BluetoothDevice> data = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Future.doWhile(() async {
        var bl = await Permission.bluetoothConnect.status;
        if (bl.isPermanentlyDenied) {
          await openAppSettings();
          return true;
        } else if (!bl.isGranted) {
          await Permission.bluetoothConnect.request();
          return true;
        }

        var blS = await Permission.bluetoothScan.status;
        if (blS.isDenied) {
          await Permission.bluetoothScan.request();
          return true;
        } else if (blS.isPermanentlyDenied) {
          await openAppSettings();
          return true;
        }
        var fineLocation = await Permission.location.status;

        if (fineLocation.isPermanentlyDenied) {
          await openAppSettings();
          return true;
        } else if (!fineLocation.isGranted) {
          await Permission.location.request();
          return true;
        }

        if ((await FlutterBluetoothSerial.instance.requestEnable()) ?? false) {
          return false;
        }
        Future.delayed(const Duration(seconds: 0x00));
        return true;
      }).then((_) async {
        data = await FlutterBluetoothSerial.instance.getBondedDevices();
      }).then((_) {
        getApplicationDocumentsDirectory().then((Directory directory) {
          File logo = File('${directory.path}/team_logo.png');
          File teamNameFile = File('${directory.path}/team_name.txt');

          logo.exists().then((exists) {
            if (!exists) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SetupPage(devices: data)));
            }
          });

          final teamname = teamNameFile.readAsStringSync();
          final img = logo.readAsBytesSync();

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DevicesScreen(
                      devices: data, teamname: teamname, img: img)));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: flavor.base,
      child: Image.asset(
        'assets/splash.png',
      ),
    );
  }
}

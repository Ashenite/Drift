import 'dart:io';

import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:drift/devices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Flavor flavor = catppuccin.mocha;

class SetupPage extends StatefulWidget {
  const SetupPage({super.key, required this.devices});

  final List<BluetoothDevice> devices;

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? image;

  final TextEditingController _teamNameController = TextEditingController();

  void selectImage() async {
    picImage(ImageSource source) async {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        return await image.readAsBytes();
      }
    }

    Uint8List? img = await picImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  void _saveProfile() {
    // Save the profile to the database
    String teamName = _teamNameController.text;

    getApplicationDocumentsDirectory().then((Directory directory) async {
      File logo = File('${directory.path}/team_logo.png');
      File teamNameFile = File('${directory.path}/team_name.txt');

      image ??=
          (await rootBundle.load('assets/sisimpur.png')).buffer.asUint8List();
      logo.writeAsBytesSync(image!);
      teamNameFile.writeAsStringSync(teamName);
    }).then((_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DevicesScreen(
                    devices: widget.devices,
                    teamname: _teamNameController.text,
                    img: image!,
                  )));
    });
    // ...
    // Navigate to the home page
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.center,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 570,
                        ),
                        decoration: const BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Text(
                                'Team Logo',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              height: 330,
                              decoration: BoxDecoration(
                                color: flavor.base,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: flavor.surface2,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: (image == null)
                                          ? Image.asset(
                                              'assets/sisimpur.png',
                                              width: 300,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.memory(
                                              image!,
                                              width: 300,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            )),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _teamNameController,
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Team Name',
                                labelStyle: TextStyle(
                                  color: flavor.text,
                                  fontWeight: FontWeight.w400,
                                ),
                                hintStyle: TextStyle(
                                  color: flavor.text,
                                  fontWeight: FontWeight.w400,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: flavor.surface2,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: flavor.mauve,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: flavor.red,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: flavor.red,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: flavor.surface0,
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        16, 20, 16, 20),
                              ),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w400),
                              cursorColor: flavor.mauve,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                if (value.length < 3 || value.length > 15) {
                                  return 'Name must be between 3 and 15 characters';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _saveProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: flavor.sapphire,
                      foregroundColor: flavor.text,
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

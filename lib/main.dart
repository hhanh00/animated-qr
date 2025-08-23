import 'dart:async';

import 'package:animated_qr/router.dart';
import 'package:animated_qr/store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:animated_qr/src/rust/api/simple.dart';
import 'package:animated_qr/src/rust/frb_generated.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RustLib.init();
  await appStore.load();
  runApp(
    MaterialApp.router(routerConfig: router, debugShowCheckedModeBanner: false),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Widget>? qrCodes;
  int i = 0;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated QR'),
        actions: [
          IconButton(onPressed: onOpen, icon: Icon(Icons.file_open)),
          IconButton(onPressed: onScan, icon: Icon(Icons.scanner)),
          IconButton(
            onPressed: () => onSettings(context),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: (qrCodes != null) ? qrCodes![i] : SizedBox.shrink(),
    );
  }

  void onOpen() async {
    final docDir = await getApplicationDocumentsDirectory();
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Choose the file you want to share",
      initialDirectory: docDir.path,
    );
    if (result != null && result.xFiles.isNotEmpty) {
      final path = result.xFiles.first.path;
      final packets = await encode(
        path: path,
        params: RaptorQParams(
          version: appStore.type,
          ecLevel: appStore.ecLevel,
          repair: appStore.repair,
        ),
      );
      router.push("/show", extra: packets);
    }
  }

  void onScan() async {
    router.push("/scan");
  }

  void onSettings(BuildContext context) async {
    await router.push("/settings");
  }
}

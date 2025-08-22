import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:animated_qr/router.dart';
import 'package:animated_qr/store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:animated_qr/src/rust/api/simple.dart';
import 'package:animated_qr/src/rust/frb_generated.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  List<Widget> qrCodes = [];
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
      body:
        (i < qrCodes.length) ? qrCodes[i] : null,
    );
  }

  void onOpen() async {
    final size = MediaQuery.of(context).size;
    final minSize = min(size.height, size.width);
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
      qrCodes = packets.map((p) {
        final qr = QrCode(appStore.type, appStore.ecLevel)
          ..addByteData(ByteData.sublistView(p));
        return Center(child: QrImageView.withQr(qr: qr, size: minSize * 0.8));
      }).toList();
      timer?.cancel();
      timer = Timer.periodic(Duration(milliseconds: appStore.delay), (_) {
        setState(() => i = (i + 1) % qrCodes.length);
      });
    }
  }

  void onScan() async {}

  void onSettings(BuildContext context) async {
    await GoRouter.of(context).push("/settings");
  }
}

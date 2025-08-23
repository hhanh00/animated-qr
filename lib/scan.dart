import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_qr/router.dart';
import 'package:animated_qr/src/rust/api/simple.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<StatefulWidget> createState() => ScanPageState();
}

class ScanPageState extends State<ScanPage> {
  Widget? scanner;
  final controller = MobileScannerController();
  Map<int, Uint8List> packets = {};

  @override
  void initState() {
    super.initState();

    Future(() async {
      final completed = Completer<Uint8List>();
      final sub = controller.barcodes.listen((qr) async {
        final barcode = qr.barcodes.first;
        var data = barcode.rawBytes!;
        if (Platform.isMacOS)
          data = getQrBytes(data: data);
        if (data.length < 16) return;
        final id = ByteData.sublistView(data).getUint32(12, Endian.big);

        if (!packets.containsKey(id)) {
          packets[id] = data;
          setState(() {});
          final result = await decode(packet: data);
          if (result != null) {
            completed.complete(result);
          }
        }
      });
      final data = await completed.future;
      sub.cancel();
      router.pop();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await FilePicker.platform.saveFile(
          dialogTitle: "Save File",
          fileName: "animated_qr",
          bytes: data,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(controller: controller),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              packets.length.toString(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

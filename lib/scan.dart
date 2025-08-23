import 'dart:async';
import 'dart:typed_data';

import 'package:animated_qr/router.dart';
import 'package:animated_qr/src/rust/api/simple.dart';
import 'package:collection/collection.dart';
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
  List<Uint8List>? packets;
  Uint8List? prev;

  @override
  void initState() {
    super.initState();

    Future(() async {
      final eq = IterableEquality();
      packets = [];
      final completed = Completer<Uint8List>();
      final sub = controller.barcodes.listen((qr) async {
        final barcode = qr.barcodes.first;
        final data = barcode.rawBytes!;
        if (prev == null || !eq.equals(data, prev)) {
          prev = data;
          packets!.add(data);
          setState(() {});
          final result = await decode(packets: packets!);
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
              (packets?.length ?? 0).toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}

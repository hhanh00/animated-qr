import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:animated_qr/store.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowPage extends StatefulWidget {
  final List<Uint8List> packets;
  const ShowPage(this.packets, {super.key});

  @override
  State<StatefulWidget> createState() => ShowPageState();
}

class ShowPageState extends State<ShowPage> {
  List<Widget>? qrCodes;
  Timer? timer;
  int i = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final minSize = min(size.height, size.width);
      qrCodes = widget.packets.map((p) {
        final qr = QrCode(appStore.type, appStore.ecLevel)
          ..addByteData(ByteData.sublistView(p));
        return Center(
          child: QrImageView.withQr(
            qr: qr,
            size: minSize * 0.8,
            gapless: false,
          ),
        );
      }).toList();
      timer = Timer.periodic(Duration(milliseconds: appStore.delay), (_) {
        setState(() => i = (i + 1) % qrCodes!.length);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: (qrCodes != null) ? qrCodes![i] : SizedBox.shrink(),
    );
  }
}

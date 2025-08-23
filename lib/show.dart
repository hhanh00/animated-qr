import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final size = MediaQuery.of(context).size;
      final minSize = min(size.height, size.width);
      qrCodes = [];
      for (var (i, p) in widget.packets.indexed) {
        final qr = QrCode(appStore.type, QrErrorCorrectLevel.levels[appStore.ecLevel])
          ..addByteData(ByteData.sublistView(p));
        final img = await textToImageProvider(i.toString());
        qrCodes!.add(Center(
          child: QrImageView.withQr(
            qr: qr,
            size: minSize * 0.8,
            gapless: false,
            embeddedImage: img,
          ),
        ));
      }
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

Future<ImageProvider> textToImageProvider(String text, {double fontSize = 40}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final textStyle = TextStyle(
    color: const Color(0xFF000000),
    fontSize: fontSize,
  );

  final textSpan = TextSpan(
    text: text,
    style: textStyle,
  );

  final tp = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );

  tp.layout();
  tp.paint(canvas, Offset.zero);

  final picture = recorder.endRecording();
  final img = await picture.toImage(tp.width.ceil(), tp.height.ceil());

  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return MemoryImage(byteData!.buffer.asUint8List());
}

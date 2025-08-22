import 'package:animated_qr/router.dart';
import 'package:animated_qr/store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:animated_qr/src/rust/api/simple.dart';
import 'package:animated_qr/src/rust/frb_generated.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RustLib.init();
  await appStore.load();
  runApp(
    MaterialApp.router(routerConfig: router, debugShowCheckedModeBanner: false),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Center(
        child: Text(
          'Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`',
        ),
      ),
    );
  }

  void onOpen() async {
    final docDir = await getApplicationDocumentsDirectory();
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Choose the file you want to share",
      initialDirectory: docDir.path,
    );
    if (result != null && result.xFiles.isNotEmpty) {
      // final f = result.xFiles.first;
      // final data = await f.readAsBytes();
      // final qr = QrCode(1, 1);
      // QrImageView(data: "");
      // await encode(data);
    }
  }

  void onScan() async {}

  void onSettings(BuildContext context) async {
    await GoRouter.of(context).push("/settings");
  }
}

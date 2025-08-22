import 'package:animated_qr/router.dart';
import 'package:animated_qr/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobx/mobx.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> with RouteAware {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPop() {
    super.didPop();
    runInAction(() async {
      final form = formKey.currentState;
      if (form == null) return;
      final int type = form.fields["type"]!.value.toInt();
      final int errorLevel = form.fields["error_level"]!.value.toInt();
      appStore.type = type;
      appStore.errorLevel = errorLevel;
      await appStore.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                FormBuilderSlider(
                  name: "type",
                  decoration: InputDecoration(
                    label: Text("QR Code Type"),
                    helper: Text("Larger types are more dense"),
                  ),
                  initialValue: appStore.type.toDouble(),
                  min: 1,
                  max: 40,
                  divisions: 39,
                ),
                FormBuilderSlider(
                  name: "error_level",
                  decoration: InputDecoration(
                    label: Text("Error Correction Level"),
                    helper: Text("higher ECL are more robust but take more space"),
                  ),
                  initialValue: appStore.errorLevel.toDouble(),
                  min: 0,
                  max: 3,
                  divisions: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:animated_qr/router.dart';
import 'package:animated_qr/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
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
      final int delay = int.parse(form.fields["delay"]!.value);
      final int repair = int.parse(form.fields["repair"]!.value);
      appStore.type = type;
      appStore.ecLevel = errorLevel;
      appStore.delay = delay;
      appStore.repair = repair;
      await appStore.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                Card(
                  elevation: 1,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: Column(
                      children: [
                        Text("QR Codes", style: t.titleMedium),
                        Gap(16),
                        FormBuilderSlider(
                          name: "type",
                          decoration: InputDecoration(
                            label: Text("QR Code Size"),
                          ),
                          initialValue: appStore.type.toDouble(),
                          min: 1,
                          max: 40,
                          divisions: 39,
                        ),
                        Gap(16),
                        FormBuilderSlider(
                          name: "error_level",
                          decoration: InputDecoration(
                            label: Text("Error Correction Level"),
                            helper: Text(
                              "higher ECL is more robust but takes more space",
                            ),
                          ),
                          initialValue: appStore.ecLevel.toDouble(),
                          min: 0,
                          max: 3,
                          divisions: 3,
                        ),
                        Gap(16),
                        FormBuilderTextField(
                          name: "delay",
                          decoration: InputDecoration(
                            label: Text("Duration between QR codes (ms)"),
                          ),
                          initialValue: appStore.delay.toString(),
                          validator: FormBuilderValidators.integer(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: Column(
                      children: [
                        Text("Fountain Codes", style: t.titleMedium),
                        Gap(8),
                        FormBuilderTextField(
                          name: "repair",
                          decoration: InputDecoration(
                            label: Text("Repair Packets"),
                          ),
                          initialValue: appStore.repair.toString(),
                          validator: FormBuilderValidators.integer(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
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

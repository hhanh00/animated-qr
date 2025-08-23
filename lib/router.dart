import 'dart:typed_data';

import 'package:animated_qr/main.dart';
import 'package:animated_qr/scan.dart';
import 'package:animated_qr/settings.dart';
import 'package:animated_qr/show.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final router = GoRouter(
  initialLocation: "/",
  navigatorKey: navigatorKey,
  observers: [routeObserver],
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(path: '/settings', builder: (context, state) => SettingsPage()),
    GoRoute(path: '/show', builder: (context, state) => ShowPage(state.extra as List<Uint8List>)),
    GoRoute(path: '/scan', builder: (context, state) => ScanPage()),
  ],
);

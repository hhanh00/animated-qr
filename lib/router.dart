import 'package:animated_qr/main.dart';
import 'package:animated_qr/settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

final router = GoRouter(
  initialLocation: "/",
  navigatorKey: navigatorKey,
  observers: [routeObserver],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(path: 'settings', builder: (context, state) => SettingsPage()),
      ],
    ),
  ],
);

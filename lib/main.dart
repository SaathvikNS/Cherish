import 'package:cherish/utils/noti_service.dart';
import 'package:cherish/utils/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cherish/layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  NotiService().initNotification();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Cherish',
      themeMode: themeController.themeMode,
      theme: ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inder'),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Inder'),
      ),
      home: const Layout(),
    );
  }
}

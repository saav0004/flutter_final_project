import 'package:flutter/material.dart';

// screens
import 'package:final_project/screens/enter_code_screen.dart';
import 'package:final_project/screens/movie_selection_screen.dart';
import 'package:final_project/screens/share_code_screen.dart';
import 'package:final_project/screens/welcome_screen.dart';

// packages
import 'dart:async';
import 'package:provider/provider.dart';

// provider
import 'package:final_project/provider/my_data_model.dart';

// id package
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';

// my key
// 'https://api.themoviedb.org/3/movie/11?api_key=516113cfd57ae5d6cb785a6c5bb76fc0'

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => MyDataModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

// code from flutter.dev
  Future<void> initPlatformState() async {
    String? deviceId;

    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    if (!mounted) return;

    context.read<MyDataModel>().setDeviceId(deviceId!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final Project',
      initialRoute: "/welcome_screen",
      routes: {
        "/welcome_screen": (context) => const WelcomeScreen(),
        "/share_code_screen": (context) => const ShareCodeScreen(),
        "/enter_code_screen": (context) => const EnterCodeScreen(),
        "/movie_selection_screen": (context) => const MovieSelectionScreen(),
      },
    );
  }
}

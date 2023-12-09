import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print('Running on ${iosInfo.identifierForVendor}');
  }

  @override
  Widget build(BuildContext context) {
    getDeviceId();
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/share_code_screen");
              },
              child: const Text('Start session'),
            ),
            const Text("Welcome to the app"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/enter_code_screen");
              },
              child: const Text('Enter code'),
            ),
          ],
        ),
      ),
    );
  }
}

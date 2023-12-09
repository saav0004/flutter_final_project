import 'package:final_project/screens/enter_code_screen.dart';
import 'package:final_project/screens/movie_selection_screen.dart';
import 'package:final_project/screens/share_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'package:final_project/provider/my_data_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyDataModel(),
      child: MaterialApp(
        title: 'Navigation Basics',
        home: const WelcomeScreen(),
        initialRoute: "/welcome_screen",
        routes: {
          "/welcome_screen": (context) => const WelcomeScreen(),
          "/share_code_screen": (context) => const ShareCodeScreen(),
          "/enter_code_screen": (context) => const EnterCodeScreen(),
          "/movie_selection_screen": (context) => const MovieSelectionScreen(),
        },
      ),
    ),
  );
}

import 'package:final_project/provider/my_data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = context.read<MyDataModel>();

    provider.setIsMatch(false);

    return const Scaffold(
      body: Center(
        child: Text('Match Screen'),
      ),
    );
  }
}

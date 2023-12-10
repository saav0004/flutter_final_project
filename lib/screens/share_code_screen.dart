import 'package:flutter/material.dart';
import 'package:final_project/utils/http_helper.dart';

// provider
import 'package:provider/provider.dart';
import 'package:final_project/provider/my_data_model.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchSession();
  }

// Create a separate method to fetch sessionx
  void _fetchSession() async {
    String url = Provider.of<MyDataModel>(context, listen: false).deviceId;
    Session session = await HttpHelper.fetchSession(
        "https://movie-night-api.onrender.com/start-session?device_id=$url");
    print(session.code);

    setState(() {
      Provider.of<MyDataModel>(context, listen: false).setCode = session.code;

      Provider.of<MyDataModel>(context, listen: false).setSessionId =
          session.sessionId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyDataModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Share code screen / Start session'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Find your session code below:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Your code: ${value.code}"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/movie_selection_screen");
                },
                child: const Text('Movie selection screen'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

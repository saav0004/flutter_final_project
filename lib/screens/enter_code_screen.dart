import 'package:flutter/material.dart';

// http helper
import 'package:final_project/utils/http_helper.dart';

// provider
import 'package:provider/provider.dart';
import 'package:final_project/provider/my_data_model.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();

  MyData _data = MyData();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  // Join session function
  void _fetchJoinSession(String code) async {
    String deviceId = Provider.of<MyDataModel>(context, listen: false).deviceId;

    String url =
        "https://movie-night-api.onrender.com/join-session?device_id=$deviceId&code=$code";

    JoinSession joinSession = await HttpHelper.joinSession(url);

    context.read<MyDataModel>().setSessionId(joinSession.sessionId);

    Navigator.pushNamed(context, "/movie_selection_screen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter code screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Find your session code below:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formStateKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: TextFormField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(
                        helperText: "Enter the code",
                        labelText: 'Code',
                        border: OutlineInputBorder(),
                        hintText: "1234"),
                    validator: (value) {
                      if (value!.isEmpty ||
                          value.length != 4 ||
                          !RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                        return 'Please enter a valid 4-digit code';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _data.code = value!;
                    },
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formStateKey.currentState!.validate()) {
                  _formStateKey.currentState!.save();

                  _fetchJoinSession(_data.code);
                } else {
                  print("Form is invalid");
                }
              },
              child: const Text('Begin'),
            )
          ],
        ),
      ),
    );
  }
}

class MyData {
  late String code;
}

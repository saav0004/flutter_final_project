import 'package:flutter/material.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  MyData _data = MyData();

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
                  margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      labelText: 'Enter your code',
                    ),
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
                if (_formStateKey.currentState?.validate() ?? false) {
                  // validate returns true if form fields are good
                  _formStateKey.currentState?.save();
                  // triggers the onSave functions in the TextFormFields
                } else {
                  // form data not valid
                }
                Navigator.pushNamed(context, "/movie_selection_screen");
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

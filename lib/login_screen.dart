import 'package:flutter/material.dart';

class LogInScreen extends StatelessWidget {
  final VoidCallback google;
  final VoidCallback facebook;
  LogInScreen({this.google, this.facebook});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 50.0,
            width: double.infinity,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: google,
              child: const Text(
                "Google Sign In",
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            height: 50.0,
            width: double.infinity,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: facebook,
              child: const Text(
                "FaceBook Sign In",
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
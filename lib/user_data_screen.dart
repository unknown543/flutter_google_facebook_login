import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  final email;
  final imageUrl, type;
  final VoidCallback logOut;
  final VoidCallback fbLogOut;
  UserData({this.email, this.imageUrl, this.logOut, this.fbLogOut, this.type});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(
            imageUrl,
            height: 200.0,
            width: 200.0,
            fit: BoxFit.cover,
          ),
          Text(email),
          RaisedButton(
            onPressed: type == "g" ? logOut : fbLogOut,
            child: const Text("Log Out"),
          )
        ],
      ),
    );
  }
}

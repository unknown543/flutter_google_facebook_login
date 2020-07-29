import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_screen.dart';
import 'user_data_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Sign In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGoogleLoggedIn = false;
  bool _isFacebookLoggedIn = false;
  String email, image;
  final _facebookLogin = FacebookLogin();
  final GoogleSignIn gSignIn = GoogleSignIn();
  GoogleSignInAccount googleSignInAccount;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;

  Future<void> _googleSignIn() async {
    try {
      googleSignInAccount = await gSignIn.signIn(); // start signi process
      // get the toakan for firebase authentication
      final GoogleSignInAuthentication gogleAuth =
          await googleSignInAccount.authentication;
      // represent the sign in user auth credential
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: gogleAuth.idToken, accessToken: gogleAuth.accessToken);
      // sign in with firebase
      user = (await auth.signInWithCredential(credential)).user;
      if (user != null) {
        _isGoogleLoggedIn = true;
        email = user.email;
        image = user.photoUrl;
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> facebookLogin() async {
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final String accesstokan = result.accessToken.token;
        final response = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$accesstokan');
        final data = json.decode(response.body);
        email = data["name"];
        image = data["first_name"];
        _isFacebookLoggedIn = true;
        setState(() {});
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("cancelled by user");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      default:
        print("something went Wrong");
    }
  }

  Future<void> _checkIsGoogleLogIn() async {
    try {
      _isGoogleLoggedIn = await gSignIn.isSignedIn();
      user = await auth.currentUser();
      if (_isGoogleLoggedIn) {
        email = user.email;
        image = user.photoUrl;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> googleSignOut() async {
    await gSignIn.signOut();
    _isGoogleLoggedIn = false;
    setState(() {});
  }

  Future<void> facebookSignOut() async {
    await _facebookLogin.logOut();
    _isFacebookLoggedIn = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _checkIsGoogleLogIn();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2));
    return Scaffold(
      appBar: AppBar(title: const Text("Social Sign In")),
      body: _isGoogleLoggedIn
          ? UserData(
              email: email,
              imageUrl: image,
              logOut: googleSignOut,
              type: "g",
            )
          : _isFacebookLoggedIn
              ? UserData(
                  email: email,
                  imageUrl: image,
                  fbLogOut: facebookSignOut,
                  type: "f",
                )
              : LogInScreen(google: _googleSignIn, facebook: facebookLogin),
    );
  }
}

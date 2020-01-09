import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:identity/identity.dart';
import 'package:identity_firebase/identity_firebase.dart';
import 'package:sso/sso.dart';

class FirebaseTwitterAuthenticator implements Authenticator {
  @override
  WidgetBuilder get action => (context) => ActionButton(
      onPressed: () => authenticate(context),
      color: Color.fromRGBO(86, 172, 239, 1),
      textColor: Colors.white,
      icon: Image.asset("images/twitter.png",
          package: "identity_firebase_twitter", width: 24, height: 24),
      text: "Sign In with Twitter");

  @override
  Future<void> authenticate(BuildContext context, [Map parameters]) async {
    AuthCredential credential = TwitterAuthProvider.getCredential(
        authToken: null, authTokenSecret: null);
    return FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((result) => FirebaseProvider.convert(result.user))
        .then((user) => Identity.of(context).user = user)
        .catchError(Identity.of(context).error);
  }
}

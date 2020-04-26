import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:identity/identity.dart';

class FirebaseTwitterAuthenticator
    with WillNotify, WillConvertUser
    implements Authenticator {
  final String consumerKey;
  final String consumerSecret;

  FirebaseTwitterAuthenticator(
      {@required this.consumerKey, @required this.consumerSecret});

  @override
  WidgetBuilder get action => (context) => ActionButton(
      onPressed: () => authenticate(context),
      color: Color.fromRGBO(3, 170, 244, 1),
      textColor: Colors.white,
      icon: Image.asset("images/twitter.png",
          package: "identity_firebase_twitter", width: 24, height: 24),
      text: "Sign in with Twitter");

  @override
  Future<void> authenticate(BuildContext context, [Map parameters]) async {
    var twitterLogin =
        TwitterLogin(consumerKey: consumerKey, consumerSecret: consumerSecret);
    final TwitterLoginResult result = await twitterLogin.authorize();
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        var session = result.session;
        AuthCredential credential = TwitterAuthProvider.getCredential(
            authToken: session.token, authTokenSecret: session.secret);
        notify(context, "Processing ...");
        return FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((result) => convert(result.user))
            .then((user) => Identity.of(context).user = user)
            .catchError(Identity.of(context).error);
        break;
      case TwitterLoginStatus.cancelledByUser:
      case TwitterLoginStatus.error:
        Identity.of(context).error(result.errorMessage);
        break;
    }
  }
}

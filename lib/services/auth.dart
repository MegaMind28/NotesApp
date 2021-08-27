import 'package:notes/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AuthService {
  static GoogleSignIn _googleSignIn = new GoogleSignIn();
  static FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromfirebaseUser(FirebaseUser user) {
    return user != null
        ? User(
            uid: user.uid,
            pic: user.photoUrl,
            email: user.email,
            displayName: user.displayName)
        : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromfirebaseUser);
  }

  static Future handleSignIn() async {
    try {
      GoogleSignIn _googleSignIn = new GoogleSignIn();
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      AuthResult result = (await _auth.signInWithCredential(credential));

      FirebaseUser user = result.user;
      Fluttertoast.showToast(
          msg: "Logged In!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2);

      return user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wrong!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2);
      print(e.toString());
      return null;
    }
  }

  static Future signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      Fluttertoast.showToast(
          msg: "Logged Out!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2);
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: "Something went wrong!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2);
      return null;
    }
  }
}

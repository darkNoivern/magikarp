import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  sign in anonymously

  Future signnanonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final currentUser = userCredential.user;
      print("Signed in with temporary account.");
      return currentUser;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }

      return null;
    }
  }

  //  sign in with email & password

  //  sign up with email & password

  //  sign out

}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pebbles/models/user.dart';
import 'package:pebbles/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // transform a firebase user into custom user
  User _fireBaseUserToUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // user stream
  Stream < User > get userAuthState {
    return _auth.onAuthStateChanged.map(_fireBaseUserToUser);
  }

  // sign in email & password
  Future signInEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = 
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _fireBaseUserToUser(result.user);
    }
    catch(e) {
      print('couldn\'t sign in');
      print(e.toString());
      return null;
    }
  }

  // sign up email & password
  Future signUpEmailAndPassword(String userName, String email, String password) async {
    try {
      AuthResult result =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      DatabaseService().createUserInstance(uid: result.user.uid, userName: userName, email: email);  
      return _fireBaseUserToUser(result.user);
    }
    catch(e) {
      print('couldn\'t sign up');
      print(e.toString());
      return null;
    }
  }

  // signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print('couldn\'t sign out');
      print(e.toString());
      return null;
    }
  }

}

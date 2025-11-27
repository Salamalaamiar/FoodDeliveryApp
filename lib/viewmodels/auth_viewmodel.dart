import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: "2878514684-hbkpuhcralbj2q6btdp99a1n2fc12b4b.apps.googleusercontent.com",
);


  /// Sign up with email/password
  Future<String?> signUp({required String email, required String password, String? fullName}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (fullName != null) {
        await userCredential.user?.updateDisplayName(fullName);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  /// Sign in with email/password
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
/// GOOGLE SIGN IN — MARCHE SUR WEB + ANDROID + IOS
  Future<String?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // WEB
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        await _auth.signInWithPopup(googleProvider);
        return null;

      } else {
        // ANDROID / IOS
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return "Sign in aborted";

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
        return null;
      }
    } catch (e) {
      return e.toString();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  /// Current user
  User? get currentUser => _auth.currentUser;
}

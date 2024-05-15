import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:auth_app/models/user.dart';
import 'package:auth_app/screens/google_sign_up.dart';
import 'package:auth_app/screens/home.dart';

final authServiceProvider = Provider<AuthServices>(
  (ref) => AuthServices(),
);

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authUserState {
    return _auth.authStateChanges();
  }

  Future<void> createUserWithEmail(
    String name,
    String email,
    String password,
    String number,
    Gender gender,
    BuildContext context,
  ) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      debugPrint('Created New Account');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }).onError((error, stackTrace) {
      debugPrint('Error ${error.toString()}');
    });

    UserModel user =
        UserModel(name: name, email: email, gender: gender, number: number);

    _db.collection('Users').doc(_auth.currentUser!.uid).set(user.toMap());
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      debugPrint('User Signed in');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }).onError((error, stackTrace) {
      debugPrint('The Error ${error.toString()}');
    });
  }

  Future<void> signInWithGoogle(
    BuildContext context,
  ) async {
    final navigator = Navigator.of(context);
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser != null) {
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      // await _auth.signInWithCredential(credential).then((value) {
      //   debugPrint('user sign in with google for details');
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const GoogleSignUpScreen()),
      //   );
      // }).onError((error, stackTrace) {
      //   debugPrint('Error ${error.toString()}');
      // });

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      ///Her to check isNewUser OR Not
      if (authResult.additionalUserInfo!.isNewUser) {
        // if (!context.mounted) return;
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const GoogleSignUpScreen()),
        );

        debugPrint('Email ${gUser.email}');
        debugPrint('Email ${gUser.displayName}');

        await _db
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .set(({'name': gUser.displayName, 'email': gUser.email}));
      } else {
        // if (!context.mounted) return;
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  Future<void> updateUserRecord(
    String name,
    String number,
  ) async {
    await _db
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .update(({'name': name, 'number': number}));
  }

  Future<void> googleUserRecord(
    String name,
    String number,
    Gender gender,
    BuildContext context,
  ) async {
    await _db
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .update(({
          'name': name,
          'gender': gender.name,
          'number': number,
        }))
        .then((value) {
      debugPrint('user sign in with google for details');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }).onError((error, stackTrace) {
      debugPrint('Error ${error.toString()}');
    });
  }

  Future<void> deleteUserAccount() async {
    final id = _auth.currentUser!.uid;
    // final currentUser = _auth.currentUser;
    // currentUser?.reauthenticateWithCredential(
    //   EmailAuthProvider.credential(
    //     email: currentUser.email!,
    //     password: 'password',
    //   ),
    // );
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      debugPrint('Error ${e.toString()}');

      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      }
    } catch (e) {
      debugPrint('Error ${e.toString()}');
      // Handle general exception
    }
    await _db.collection('Users').doc(id).delete();
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData = _auth.currentUser!.providerData.first;

      if (GoogleAuthProvider().providerId == providerData.providerId) {
        await _auth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await _auth.currentUser!.delete();
    } catch (e) {
      debugPrint('Error ${e.toString()}');
      // Handle exceptions
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:auth_app/services/auth_services.dart';
import 'package:auth_app/models/user.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(ref.watch(authServiceProvider)),
);

final authStreamProvider =
    StreamProvider<User?>((ref) => AuthServices().authUserState);

class AuthController extends StateNotifier<bool> {
  AuthController(this._authServices) : super(false);

  final AuthServices _authServices;

  Future<void> createAccount({
    required String name,
    required String email,
    required String password,
    required String number,
    required Gender gender,
    required BuildContext context,
  }) async {
    try {
      state = true;
      await _authServices.createUserWithEmail(
        name,
        email,
        password,
        number,
        gender,
        context,
      );
    } catch (e) {
      state = false;
    }
  }

  Future<void> logInEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      state = true;
      await _authServices.signInWithEmailAndPassword(
        email,
        password,
        context,
      );
    } catch (e) {
      state = false;
    }
  }

  Future<void> logInGoogle({
    required BuildContext context,
  }) async {
    try {
      state = true;
      await _authServices.signInWithGoogle(
        context,
      );
    } catch (e) {
      state = false;
    }
  }

  Future<void> updateUser({
    required String name,
    required String number,
  }) async {
    try {
      state = true;
      await _authServices.updateUserRecord(name, number);
    } catch (e) {
      state = false;
    }
  }

  Future<void> googleUserRecord({
    required String name,
    required String number,
    required Gender gender,
    required BuildContext context,
  }) async {
    try {
      state = true;
      await _authServices.googleUserRecord(name, number, gender, context);
    } catch (e) {
      state = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      state = true;
      await _authServices.deleteUserAccount();
    } catch (e) {
      state = false;
    }
  }
}

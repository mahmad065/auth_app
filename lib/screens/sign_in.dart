import 'package:flutter/material.dart';

import 'package:auth_app/screens/sign_up.dart';
import 'package:auth_app/widgets/signin_signup_button.dart';
import 'package:auth_app/widgets/text_field.dart';
import 'package:auth_app/services/auth_services.dart';
import 'package:auth_app/controllers/auth_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _authServices = AuthServices();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = AuthController(_authServices);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 241, 56, 118),
              Color.fromARGB(255, 109, 61, 194),
              Color.fromARGB(255, 18, 140, 239),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.3, 20, 0),
          child: Column(
            children: [
              reusableTextField(
                icon: Icons.person_outline,
                text: 'Enter Email',
                isPassword: false,
                controller: _emailTextController,
                keyboard: TextInputType.emailAddress,
                readText: false,
              ),
              const SizedBox(
                height: 24,
              ),
              reusableTextField(
                icon: Icons.lock_outline,
                text: 'Enter Password',
                isPassword: true,
                controller: _passwordTextController,
                keyboard: TextInputType.visiblePassword,
                readText: false,
              ),
              const SizedBox(
                height: 24,
              ),
              signInSignUpButton(
                context: context,
                text: 'LOG IN',
                onTap: () => authController.logInEmail(
                  email: _emailTextController.text,
                  password: _passwordTextController.text,
                  context: context,
                ),
              ),
              signUpOption(context),
              const SizedBox(
                height: 40,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      endIndent: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Or Continue With',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              InkWell(
                onTap: () => authController.logInGoogle(
                  context: context,
                ),
                focusColor: Colors.black,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200]),
                  child: Image.asset(
                    'assets/Google_Logo.png',
                    height: 40,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Don\'t Have Account?  ',
        style: TextStyle(color: Colors.white),
      ),
      InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            ),
          );
        },
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    ],
  );
}

import 'package:flutter/material.dart';

import 'package:auth_app/services/auth_services.dart';
import 'package:auth_app/screens/sign_in.dart';
import 'package:auth_app/widgets/signin_signup_button.dart';
import 'package:auth_app/widgets/text_field.dart';
import 'package:auth_app/controllers/auth_controller.dart';
import 'package:auth_app/models/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _numberTextController = TextEditingController();
  final _genderTextController = TextEditingController();
  final _authServices = AuthServices();
  Gender? dropdownValue;

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _numberTextController.dispose();
    _genderTextController.dispose();
    super.dispose();
  }

  void dropDownCallback(Gender? selectedValue) {
    setState(() {
      dropdownValue = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = AuthController(_authServices);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: [
              reusableTextField(
                icon: Icons.person_outline,
                text: 'Enter Full Name',
                isPassword: false,
                controller: _nameTextController,
                keyboard: TextInputType.name,
                readText: false,
              ),
              const SizedBox(height: 24),
              reusableTextField(
                icon: Icons.email_outlined,
                text: 'Enter Eamil',
                isPassword: false,
                controller: _emailTextController,
                keyboard: TextInputType.emailAddress,
                readText: false,
              ),

              const SizedBox(height: 24),
              reusableTextField(
                icon: Icons.phone,
                text: 'Enter Phone Number',
                isPassword: false,
                controller: _numberTextController,
                keyboard: TextInputType.number,
                readText: false,
              ),
              const SizedBox(height: 24),
              reusableTextField(
                icon: Icons.lock_outline,
                text: 'Enter Password',
                isPassword: true,
                controller: _passwordTextController,
                keyboard: TextInputType.visiblePassword,
                readText: false,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.3),
                ),
                width: 400,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 24),
                  child: DropdownButtonFormField(
                    value: dropdownValue,
                    items: const [
                      DropdownMenuItem(
                        value: Gender.male,
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: Gender.female,
                        child: Text('Female'),
                      ),
                    ],
                    decoration: InputDecoration(
                        icon: getIcon(dropdownValue),
                        iconColor: Colors.white70,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                    borderRadius: BorderRadius.circular(30),
                    alignment: Alignment.centerLeft,
                    isExpanded: true,
                    hint: Text(
                      'Select Gender',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                      ),
                    ),
                    dropdownColor: const Color.fromARGB(210, 109, 61, 194),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                    ),
                    iconSize: 40,
                    iconEnabledColor: Colors.white.withOpacity(0.9),
                    onChanged: dropDownCallback,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              signInSignUpButton(
                  context: context,
                  text: 'SIGN UP',
                  onTap: () => authController.createAccount(
                        name: _nameTextController.text,
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                        number: _numberTextController.text,
                        gender: dropdownValue!,
                        context: context,
                      )),
              // const SizedBox(
              //   height: 40,
              // ),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Expanded(
              //       child: Divider(
              //         endIndent: 12,
              //         color: Colors.white70,
              //       ),
              //     ),
              //     Text(
              //       'Or Continue With',
              //       style: TextStyle(color: Colors.white70, fontSize: 14),
              //     ),
              //     Expanded(
              //       child: Divider(
              //         indent: 12,
              //         color: Colors.white70,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 48,
              // ),
              // InkWell(
              //   onTap: () => authController.logInGoogle(
              //     context: context,
              //   ),
              //   focusColor: Colors.black,
              //   child: Container(
              //     padding: const EdgeInsets.all(20),
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.white),
              //         borderRadius: BorderRadius.circular(16),
              //         color: Colors.grey[200]),
              //     child: Image.asset(
              //       'assets/Google_Logo.png',
              //       height: 40,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

getIcon(Gender? dropdownValue) {
  if (dropdownValue == Gender.male) {
    return const Icon(
      Icons.male,
      size: 25,
    );
  }
  if (dropdownValue == Gender.female) {
    return const Icon(
      Icons.female,
      size: 25,
    );
  }
  return null;
}

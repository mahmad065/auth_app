import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:auth_app/widgets/text_field.dart';
import 'package:auth_app/widgets/signin_signup_button.dart';
import 'package:auth_app/controllers/auth_controller.dart';
import 'package:auth_app/services/auth_services.dart';
import 'package:auth_app/models/user.dart';

class GoogleSignUpScreen extends StatefulWidget {
  const GoogleSignUpScreen({super.key});

  @override
  State<GoogleSignUpScreen> createState() => _GoogleSignUpScreenState();
}

class _GoogleSignUpScreenState extends State<GoogleSignUpScreen> {
  late TextEditingController _emailTextController;
  late TextEditingController _nameTextController;
  final _numberTextController = TextEditingController();
  final _genderTextController = TextEditingController();

  final _authServices = AuthServices();
  Gender? dropdownValue;

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
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
        title: const Text(
          'Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 24,
                  ),
                  signInSignUpButton(
                    context: context,
                    text: 'Edit Profile',
                    onTap: () {},
                  )
                ],
              ),
            );
          } else {
            Map<String, dynamic>? data =
                snapshot.data?.data() as Map<String, dynamic>;
            String userEmail = data['email'];
            String userName = data['name'];

            _nameTextController = TextEditingController(text: userName);
            _emailTextController = TextEditingController(text: userEmail);

            return Container(
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
                    20, MediaQuery.of(context).size.height * 0.35, 20, 0),
                child: Column(
                  children: [
                    reusableTextField(
                      icon: Icons.email_outlined,
                      text: userEmail,
                      isPassword: false,
                      controller: _emailTextController,
                      keyboard: TextInputType.emailAddress,
                      readText: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    reusableTextField(
                      icon: Icons.person_outline,
                      text: userName,
                      isPassword: false,
                      controller: _nameTextController,
                      keyboard: TextInputType.name,
                      readText: false,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    reusableTextField(
                      icon: Icons.phone,
                      text: 'Enter Phone Number',
                      isPassword: false,
                      controller: _numberTextController,
                      keyboard: TextInputType.number,
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
                          dropdownColor:
                              const Color.fromARGB(210, 109, 61, 194),
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
                    const SizedBox(
                      height: 32,
                    ),
                    signInSignUpButton(
                      context: context,
                      text: 'Sign In',
                      onTap: () {
                        authController.googleUserRecord(
                          name: _nameTextController.text,
                          number: _numberTextController.text,
                          gender: dropdownValue!,
                          context: context,
                        );
                        debugPrint(_nameTextController.text);
                        debugPrint(_emailTextController.text);
                        debugPrint(_numberTextController.text);
                        debugPrint(dropdownValue!.name);
                      },
                    )
                  ],
                ),
              ),
            );
          }
        },
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

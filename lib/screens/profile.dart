import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:auth_app/widgets/text_field.dart';
import 'package:auth_app/widgets/signin_signup_button.dart';
import 'package:auth_app/controllers/auth_controller.dart';
import 'package:auth_app/services/auth_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _numberTextController;

  final _authServices = AuthServices();

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _numberTextController.dispose();
    super.dispose();
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
          'Your Profile',
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
            String userNumber = data['number'];
            _nameTextController = TextEditingController(text: userName);
            _emailTextController = TextEditingController(text: userEmail);
            _numberTextController = TextEditingController(text: userNumber);
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
                      text: userNumber,
                      isPassword: false,
                      controller: _numberTextController,
                      keyboard: TextInputType.number,
                      readText: false,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    signInSignUpButton(
                      context: context,
                      text: 'Edit Profile',
                      onTap: () {
                        authController.updateUser(
                          name: _nameTextController.text,
                          number: _numberTextController.text,
                        );
                        debugPrint(_nameTextController.text);
                        debugPrint(_emailTextController.text);
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

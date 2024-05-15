import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:auth_app/screens/sign_in.dart';
import 'package:auth_app/screens/profile.dart';
import 'package:auth_app/controllers/auth_controller.dart';
import 'package:auth_app/services/auth_services.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authServices = AuthServices();
    final authController = AuthController(authServices);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          debugPrint('Signed Out');
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                          );
                        });
                      },
                      child: const Text('LOG OUT'),
                    ),
                  ],
                ),
              );
            } else {
              Map<String, dynamic>? data =
                  snapshot.data?.data() as Map<String, dynamic>;
              String userEmail = data['email'];
              String userName = data['name'];
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Hi, $userName'),
                    const SizedBox(height: 12),
                    Text('Email: $userEmail'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          debugPrint('Signed Out');
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(140, 40),
                      ),
                      child: const Text('LOG OUT'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(140, 40),
                      ),
                      child: const Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(180, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        authController.deleteAccount();
                        // deleteDialog(context, authController.deleteAccount());
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 40),
                      ),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}

deleteDialog(
  BuildContext context,
  Future<void> delete,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete your Account?'),
        content: const Text(
            '''If you select Delete we will delete your account on our server.

Your app data will also be deleted and you won't be able to retrieve it.

Since this is a security-sensitive operation, you eventually are asked to login before your account can be deleted.'''),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              delete;
            },
          ),
        ],
      );
    },
  );
}





// Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       body: Container(
        
//         height: MediaQuery.of(context).size.height * 0.2,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               flex: 2,
//               child: StreamBuilder<DocumentSnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('Users')
//                       .doc(firebaseUser.uid)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     Map<String, dynamic>? data =
//                         snapshot.data?.data() as Map<String, dynamic>;
//                     String userEmail = data['email'];
//                     String userName = data['name'];
//                     return SizedBox(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('Hi, $userName'),
//                           const SizedBox(height: 12),
//                           Text('Email: $userEmail'),
//                         ],
//                       ),
//                     );
//                   }),
//             ),
//             // const SizedBox(height: 24),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   FirebaseAuth.instance.signOut().then((value) {
//                     debugPrint('Signed Out');
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                           builder: (context) => const SignInScreen()),
//                     );
//                   });
//                 },
//                 child: const Text('LOG OUT'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

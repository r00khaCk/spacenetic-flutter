// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spacenetic_flutter/Functions/show_snackbar.dart';
import 'package:spacenetic_flutter/UI/homepage.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  //Email sign up function
  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    //Check username availability
    final usernameAvailable = await _usernameAvailable(username);

    if (!usernameAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This username is unavailable.'),
        ),
      );
      return;
    }

    //Validate username
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a username.'),
        ),
      );
      return;
    }

    //Validate email and password
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password.'),
        ),
      );
      return;
    }

    //Check email validity
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email.'),
        ),
      );
      return;
    }

    //Check password length
    if (password.length <= 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long'),
        ),
      );
      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verification link sent!'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create account. Please try again later.'),
        ),
      );
    }
  }

  Future<bool> _usernameAvailable(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  //Login with email
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    //Validate email and password
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email and password are required.'),
        ),
      );
      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = 'Invalid email or password. Please try again.';
          break;
        default:
          errorMessage = 'An error occured. Please try again later.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
      print('Login failed: $errorMessage');
    }
    // on FirebaseAuthException catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Invalid email or password. Please try again.'),
    //     ),
    //   );
    //   return;
    // }
  }

  //Send email verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verification sent!'),
        ),
      );
      return;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to send email verification. Please try again later.'),
        ),
      );
      return;
    }
  }

  //Google sign in (not working)
//   Future<void> signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser?.authentication;

//       if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth?.accessToken,
//           idToken: googleAuth?.idToken,
//         );
//         UserCredential userCredential =
//             await _auth.signInWithCredential(credential);
//         if (userCredential.user != null) {
//           if (userCredential.additionalUserInfo!.isNewUser) {
//             //Obtain user's basic information from Google account
//             final googleUserInfo = googleUser?.email != null
//                 ? {
//                     'name': googleUser?.displayName ?? '',
//                     'email': googleUser?.email ?? '',
//                   }
//                 : null;

//             //Create a new user account in Firebase and store their basic information
//             final email = googleUser?.email;
//             if (email != null) {
//               await _auth.currentUser!.updateEmail(email);
//             }
//             await _auth.currentUser!.updatePassword('google_sign_in_only');
//             await FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(userCredential.user!.uid)
//                 .set(googleUserInfo ?? {});

//             //Navigate new user to Homepage after successful login
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (_) => const HomePage()),
//             );
//           } else {
//             //Navigate existing user to Homepage after successful login
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (_) => const HomePage()),
//             );
//           }
//         } else {
//           await _auth.signOut();
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('To use the app, please sign up.'),
//             ),
//           );
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content:
//               Text('Error signing in with Google. Please try again later.'),
//         ),
//       );
//       return;
//     }
//   }
// }

  //Google sign in
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
      //   throw Exception('Failed to authenticate with Google.');
      // }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // if (userCredential.user == null) {
      //   throw Exception('Failed to sign in with Google.');
      // }

      if (userCredential.additionalUserInfo!.isNewUser) {
        // Obtain user's basic information from Google account
        final googleUserInfo = googleUser?.email != null
            ? {
                'name': googleUser?.displayName ?? '',
                'email': googleUser?.email ?? '',
              }
            : null;

        // Create a new user account in Firebase and store their basic information
        final email = googleUser?.email;
        if (email != null) {
          await FirebaseAuth.instance.currentUser!
              .updateEmail(email)
              .catchError((e) {
            throw Exception('Failed to update email.');
          });
        }

        await FirebaseAuth.instance.currentUser!
            .updatePassword('google_sign_in_only')
            .catchError((e) {
          throw Exception('Failed to update password.');
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(googleUserInfo ?? {})
            .catchError((e) {
          throw Exception('Failed to store user information.');
        });

        // Navigate new user to Homepage after successful login
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        // Navigate existing user to Homepage after successful login
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomePage(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      }
    } catch (e) {
      // Catch any general exceptions that may occur during the function execution
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to sign in with Google. Please try again later.'),
        ),
      );
      return;
    }
  }
}

// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  Stream<User?> get user => _auth.idTokenChanges();

  //Email sign up function
  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    //Store username in Firestore
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final userData = {
          'uid': userCredential.user!.uid,
          'username': username, // Add username to the userData map
          'email': email,
        };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
                userData); // Create a new document with the user's UID as its document ID and store the user's information in Cloud Firestore
        //Log the user in
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        //Get the signed in user
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error storing username: $e'),
        ),
      );
      return;
    }

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
      // print('Error: $e');
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
      StreamSubscription<User?>? userSubscription;

      userSubscription =
          FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (!_auth.currentUser!.emailVerified) {
          await sendEmailVerification(context);
        }
        Navigator.pushReplacementNamed(context, '/home');

        await userSubscription?.cancel();
      });
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
        case 'email-already-in-use':
          errorMessage =
              'The email address is already in use by another account.';
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

  //Reset user password
  Future<void> resetPassword(
      {required String email, required BuildContext context}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent!'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send password reset email.'),
        ),
      );
    }
  }

  //Google sign in
  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     // if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
  //     //   throw Exception('Failed to authenticate with Google.');
  //     // }

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     // if (userCredential.user == null) {
  //     //   throw Exception('Failed to sign in with Google.');
  //     // }

  //     if (userCredential.additionalUserInfo!.isNewUser) {
  //       // Obtain user's basic information from Google account
  //       final googleUserInfo = googleUser?.email != null
  //           ? {
  //               'name': googleUser?.displayName ?? '',
  //               'email': googleUser?.email ?? '',
  //             }
  //           : null;

  //       // Create a new user account in Firebase and store their basic information
  //       final email = googleUser?.email;
  //       if (email != null) {
  //         await FirebaseAuth.instance.currentUser!
  //             .updateEmail(email)
  //             .catchError((e) {
  //           throw Exception('Failed to update email.');
  //         });
  //       }

  //       await FirebaseAuth.instance.currentUser!
  //           .updatePassword('google_sign_in_only')
  //           .catchError((e) {
  //         throw Exception('Failed to update password.');
  //       });

  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userCredential.user!.uid)
  //           .set(googleUserInfo ?? {})
  //           .catchError((e) {
  //         throw Exception('Failed to store user information.');
  //       });

  //       // Navigate new user to Homepage after successful login
  //       Navigator.pushNamed(context, '/home');
  //     } else {
  //       // Navigate existing user to Homepage after successful login
  //       Navigator.pushNamed(context, '/home');
  //     }
  //   } catch (e) {
  //     // Catch any general exceptions that may occur during the function execution
  //     await FirebaseAuth.instance.signOut();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content:
  //             Text('Failed to sign in with Google. Please try again later.'),
  //       ),
  //     );
  //     Navigator.pushNamed(context, '/main');
  //   }
  // }

  //Google sign in with currentUser stored
  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     StreamSubscription<User?>? userSubscription;

  //     userSubscription =
  //         FirebaseAuth.instance.authStateChanges().listen((User? user) async {
  //       if (user != null) {
  //         if (userCredential.additionalUserInfo!.isNewUser) {
  //           // Obtain user's basic information from Google account
  //           final googleUserInfo = googleUser?.email != null
  //               ? {
  //                   'name': googleUser?.displayName ?? '',
  //                   'email': googleUser?.email ?? '',
  //                 }
  //               : null;

  //           // Create a new user account in Firebase and store their basic information
  //           final email = googleUser?.email;
  //           if (email != null) {
  //             await user.updateEmail(email).catchError((e) {
  //               throw Exception('Failed to update email.');
  //             });
  //           }

  //           await user.updatePassword('google_sign_in_only').catchError((e) {
  //             throw Exception('Failed to update password.');
  //           });

  //           await FirebaseFirestore.instance
  //               .collection('users')
  //               .doc(user.uid)
  //               .set(googleUserInfo ?? {})
  //               .catchError((e) {
  //             throw Exception('Failed to store user information.');
  //           });

  //           // Navigate new user to Homepage after successful login
  //           Navigator.pushReplacementNamed(context, '/home');
  //         } else {
  //           // Navigate existing user to Homepage after successful login
  //           Navigator.pushReplacementNamed(context, '/home');
  //         }

  //         await userSubscription?.cancel();
  //       }
  //     });
  //   } catch (e) {
  //     // Catch any general exceptions that may occur during the function execution
  //     await FirebaseAuth.instance.signOut();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content:
  //             Text('Failed to sign in with Google. Please try again later.'),
  //       ),
  //     );
  //     Navigator.pushNamed(context, '/main');
  //   }
  // }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = userCredential.user!;
        if (userCredential.additionalUserInfo!.isNewUser) {
          // Obtain user's basic information from Google account
          final googleUserInfo = googleUser?.email != null
              ? {
                  'name': googleUser?.displayName ?? '',
                  'email': googleUser?.email ?? '',
                }
              : null;

          // Update user's profile with their display name
          final displayName = googleUser?.displayName;
          if (displayName != null) {
            await user.updateDisplayName(displayName);
          }

          // Create a new user document in Firest'ore and store their basic information
          final userData = {
            'uid': userCredential.user!.uid,
            'displayName': user.displayName ?? '',
            'email': user.email ?? '',
          };
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(googleUserInfo ?? {})
              .catchError((e) {
            throw Exception('Failed to store user information.');
          });

          // Navigate new user to Homepage after successful login
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Navigate existing user to Homepage after successful login
          Navigator.pushReplacementNamed(context, '/home');
        }
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
      Navigator.pushNamed(context, '/main');
    }
  }

  Future<void> signOutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/main');
  }
}

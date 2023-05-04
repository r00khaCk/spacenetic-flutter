import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:spacenetic_flutter/Functions/fetch_potdAPI.dart';
import 'package:spacenetic_flutter/Services/firebase_auth_methods.dart';

class SignUpPage extends StatefulWidget {
  static String routeName = '/signup';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // final formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _username = '';
  String _email = '';
  String _password = '';

  void signUpUser() async {
    FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmail(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        context: context);
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<String> fetchAPOD() async {
    final api = FetchPotdAPI();
    final response = await http.get(
        Uri.parse(
            'https://api.nasa.gov/planetary/apod?api_key=${api.nasaAPIKey}'),
        headers: {'X-API-key': api.nasaAPIKey});
    final jsonData = jsonDecode(response.body);
    final apodUrl = jsonData['url'] as String?;
    if (apodUrl != null) {
      return apodUrl;
    } else {
      throw Exception('Failed to load APOD url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
          future: fetchAPOD(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final apodUrl = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: apodUrl != null
                        ? DecorationImage(
                            image: NetworkImage(apodUrl),
                            fit: BoxFit.fill,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign Up',
                              style: GoogleFonts.orbitron(
                                  fontSize: 48.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 30.0),
                            TextFormField(
                              controller: _usernameController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _username = value.trim();
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address.';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _email = value.trim();
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password.';
                                }
                                if (value.length <= 7) {
                                  return 'Password must be at least 8 characters.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _password = value.trim();
                                });
                              },
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 44.0),
                            ElevatedButton(
                              onPressed: signUpUser,
                              // onPressed: () {
                              //   if (formKey.currentState!.validate()) {
                              //     signUpUser();
                              //   }
                              // },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 93.0),
                                elevation: 5,
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            Row(
                              children: const [
                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.0,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'Or sign in with',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 8.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  FirebaseAuthMethods(FirebaseAuth.instance)
                                      .signInWithGoogle(context);
                                },
                                icon: Image.asset(
                                  'assets/images/google_logo.png',
                                  height: 24,
                                  width: 24,
                                ),
                                label: const Text(
                                  'Sign In with Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.grey[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: const Size(280, 48),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 20.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 98.0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      //Navigate user to sign up page
                                      Navigator.pushNamed(context, '/signin');
                                    },
                                    child: const Text(
                                      "Sign in.",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

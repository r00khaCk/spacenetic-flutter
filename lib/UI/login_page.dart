import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacenetic_flutter/Functions/fetch_potdAPI.dart';
import 'package:spacenetic_flutter/Classes/login_modal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacenetic_flutter/UI/homepage.dart';

void main() => runApp(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );
          },
        ),
      ),
    );

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginModal _loginModal = LoginModal(email: '', password: '');
  late Map<String, dynamic> _apodResponse;

  @override
  void initState() {
    super.initState();
    fetchAPOD();
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const HomePage(),
    ));
  }

  Future<void> fetchAPOD() async {
    final api = FetchPotdAPI();
    final response = await http.get(
        Uri.parse(
            'https://api.nasa.gov/planetary/apod?api_key=${api.nasaAPIKey}'),
        headers: {'X-API-key': api.nasaAPIKey});
    final jsonData = jsonDecode(response.body);
    setState(() {
      _apodResponse = jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apodUrl = _apodResponse['url'] as String?;
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black87,
                Colors.black87,
                Colors.blueGrey.shade800,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: apodUrl != null
                          ? DecorationImage(
                              image: NetworkImage(apodUrl),
                              fit: BoxFit.cover,
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
                                'Login',
                                style: GoogleFonts.orbitron(
                                  fontSize: 48.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
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
                                    _loginModal.email = value.trim();
                                  });
                                },
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                obscureText: true,
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
                                    _loginModal.password = value.trim();
                                  });
                                },
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 32.0),
                              ElevatedButton(
                                onPressed: () {
                                  navigateToHomePage(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 100.0),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

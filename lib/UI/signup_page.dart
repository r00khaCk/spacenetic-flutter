import 'package:firebase_auth/firebase_auth.dart';
import 'package:spacenetic_flutter/Services/firebase_auth_methods.dart';
import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const SignUpPage());
// }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sign Up',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 16.0),
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
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black54,
              ),
            ),
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
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black54,
              ),
            ),
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
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 32.0),
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
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0),
              elevation: 5,
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

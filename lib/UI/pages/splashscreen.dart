import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashscreenPage extends StatelessWidget {
  const SplashscreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Wait for 10 seconds then navigate user to the sign in page
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, '/signin');
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurple, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.4, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 100.0,
                child: SizedBox(
                  width: 200.0,
                  height: 200.0,
                  child: Lottie.asset(
                    'assets/animations/splashscreen.json',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'SPACENETIC',
              style: GoogleFonts.orbitron(fontSize: 40.0, color: Colors.white),
            ),
            const SizedBox(height: 30.0),
            Text(
              'Discover the solar system with us',
              style: GoogleFonts.abel(fontSize: 20.0, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Explore the wonders of the universe',
              style: GoogleFonts.abel(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

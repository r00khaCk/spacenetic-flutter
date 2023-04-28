import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/main-bg.png"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 40),
                child: Row(
                  children: [
                    Container(
                        width: 150,
                        height: 80,
                        padding: const EdgeInsets.only(left: 20, top: 35),
                        child: const Text(
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                            "Hi user,")),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 20, top: 40),
                      child: SizedBox(
                          height: 45,
                          child: Icon(
                            Icons.menu,
                            size: 35,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 200,
                    height: 50,
                    padding: const EdgeInsets.only(left: 30),
                    child: const Text(
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                        "Let's Explore")),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

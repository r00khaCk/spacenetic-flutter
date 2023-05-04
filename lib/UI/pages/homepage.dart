import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';
import 'package:spacenetic_flutter/Classes/planets_local_modal.dart';
import 'package:spacenetic_flutter/Functions/fetch_potdAPI.dart';
import 'package:spacenetic_flutter/UI/pages/planet_description_page.dart';
import 'package:spacenetic_flutter/UI/widgets/frostedglass.dart';
import 'package:spacenetic_flutter/Services/firebase_auth_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PlanetsLocalModal> planetObject = [];
  // late Future<List<PlanetsAPIModal>> planetApiModal;
  List<PlanetsAPIModal> planetAPI = [];

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/planet_details.json');
  }

  @override
  void initState() {
    fetchPlanetsInfo();
    super.initState();
  }

  void signOutUser() async {
    FirebaseAuthMethods(FirebaseAuth.instance).signOutUser(context);
  }

  Future<void> fetchPlanetsInfo() async {
    String jsonPlanetInfo = await loadAsset();

    Map<String, dynamic> jsonObj = jsonDecode(jsonPlanetInfo);

    List<dynamic> jsonObjList = jsonObj['planet_details'];
    setState(() {
      planetObject =
          jsonObjList.map((e) => PlanetsLocalModal.fromJson(e)).toList();
    });
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
    Widget _createHeader() {
      return FutureBuilder<String>(
          future: fetchAPOD(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 13, 28, 121),
                  ),
                  child: Center(
                    child: FrostedGlassBox(
                      theHeight: 140,
                      theWidth: 250,
                      theChild: Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 13, 28, 121),
                  ),
                  child: Center(
                    child: FrostedGlassBox(
                      theHeight: 140,
                      theWidth: 250,
                      theChild: Text('Error: ${snapshot.error}'),
                    ),
                  ),
                );
              }
            }
            return const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 13, 28, 121),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/main-bg.png"),
            fit: BoxFit.cover,
            scale: 2.0,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 150,
                    height: 80,
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, bottom: 5),
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Text(
                            'Hi User,',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          );
                        }
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final username = data['username'] ?? 'User';
                        return Text(
                          'Hi $username,', // add this line
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, left: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  //margin: EdgeInsets.only(right: 10),
                  width: 330,
                  height: 50,
                  padding: const EdgeInsets.only(
                    right: 40,
                  ),
                  child: Text(
                    // style: TextStyle(
                    //   fontSize: 20,
                    //   color: Colors.white,
                    // ),
                    "Let's Explore Our Solar System!",
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            ),
            planetObject.isEmpty
                ? const CircularProgressIndicator()
                : Expanded(
                    child: Center(
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                            height: 400,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.5),
                        itemCount: planetObject.length,
                        itemBuilder: (context, index, realIndex) {
                          final planetImage =
                              planetObject[index].imagePath ?? "";
                          final planetName = planetObject[index].name ?? "";
                          return buildImage(planetImage, planetName, index);
                        },
                      ),
                    ),
                  )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            ListTile(
              title: Text(
                "Timeline",
                style: GoogleFonts.orbitron(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/timeline');
              },
            ),
            // Not implemented
            // ListTile(
            //   title: Text(
            //     "Favourite Planets",
            //     style: GoogleFonts.orbitron(
            //       fontSize: 15,
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   onTap: () {
            //     // Navigator.of(context).push(MaterialPageRoute(
            //     //     builder: (context) => const TimelinePage()));
            //   },
            // ),
            const Expanded(
              child: SizedBox(
                height: 280,
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout_sharp),
                  title: Text(
                    "Logout",
                    style: GoogleFonts.orbitron(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    signOutUser();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildImage(String planetImage, String planetName, int index) => Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPlanetDetails(
                      planetsLocalModal1: planetObject[index],
                    ),
                  ),
                );
              },
              child: Hero(
                tag: planetImage,
                child: Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 300,
                          height: 100,
                        ),
                        FrostedGlassBox(
                          theWidth: 250,
                          theHeight: 250,
                          theChild: Text(
                            planetName,
                            style: GoogleFonts.orbitron(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 100,
                    top: 10,
                    child: Image.asset(
                      planetImage,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      );
}

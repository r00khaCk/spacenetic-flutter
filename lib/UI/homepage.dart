import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';
import 'package:spacenetic_flutter/Classes/planets_local_modal.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spacenetic_flutter/UI/planet_description_page.dart';
import 'package:spacenetic_flutter/Functions/fetch_planetAPI.dart';

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

  Future<void> fetchPlanetsInfo() async {
    String jsonPlanetInfo = await loadAsset();

    Map<String, dynamic> jsonObj = jsonDecode(jsonPlanetInfo);

    List<dynamic> jsonObjList = jsonObj['planet_details'];
    setState(() {
      planetObject =
          jsonObjList.map((e) => PlanetsLocalModal.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 50),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 20, top: 0),
                    child: SizedBox(
                        height: 35,
                        child: Icon(
                          Icons.menu,
                          size: 35,
                          color: Colors.white,
                        )),
                  ),
                  const Spacer(),
                  Container(
                      width: 150,
                      height: 80,
                      padding:
                          const EdgeInsets.only(left: 20, top: 20, bottom: 5),
                      child: const Text(
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                          "Hi User,")),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    //margin: EdgeInsets.only(right: 10),
                    width: 320,
                    height: 30,
                    padding: const EdgeInsets.only(
                      left: 75,
                    ),
                    child: const Text(
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                        "Let's Explore Our Solar System!")),
              ]),
            ),
            planetObject.isEmpty
                ? const CircularProgressIndicator()
                : Expanded(
                    child: Center(
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                            height: 300,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.6),
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
    );
  }

  Widget buildImage(String planetImage, String planetName, int index) => Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //margin: EdgeInsets.symmetric(horizontal: 5),
        // color: Colors.grey,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlanetDetailsPage(
                    planetsLocalModal: planetObject[index],
                  ),
                ));
              },
              child: Hero(
                tag: planetImage,
                child: SizedBox(
                  height: 300,
                  child: Image.asset(
                    planetImage,
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                ),
              ),
            ),
          ),
          Text(
            planetName,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          )
        ],
      );
}

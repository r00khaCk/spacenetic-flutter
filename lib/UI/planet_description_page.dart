import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';
import 'package:spacenetic_flutter/Classes/planets_local_modal.dart';
import 'package:flutter/material.dart';
import 'package:spacenetic_flutter/Functions/fetch_planetAPI.dart';
import 'package:spacenetic_flutter/UI/widgets/frostedglass.dart';

class PlanetDetailsPage extends StatefulWidget {
  //final PlanetDetails planetDetails;
  final PlanetsLocalModal planetsLocalModal;
  //late Future<PlanetsAPIModal> planetsAPIModal;
  // final Future<List<PlanetsAPIModal>> planetsAPIModal;
  const PlanetDetailsPage({Key? key, required this.planetsLocalModal})
      : super(key: key);

  @override
  State<PlanetDetailsPage> createState() => _PlanetDetailsPageState();
}

class _PlanetDetailsPageState extends State<PlanetDetailsPage> {
  late Future<List<PlanetsAPIModal>> planetsAPIModal;
  FetchPlanetAPI fetchPlanetAPI = FetchPlanetAPI();
  @override
  void initState() {
    // TODO: implement initState
    String? name = widget.planetsLocalModal.name;
    planetsAPIModal = fetchPlanetAPI.getPlanetAPI(name!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage("assets/images/main-bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.grey.withOpacity(1.0), BlendMode.multiply)),
        ),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 391,
                          height: 200,
                          child: Row(
                            children: [
                              Hero(
                                tag: widget.planetsLocalModal.imagePath
                                    .toString(),
                                child: SizedBox(
                                  height:
                                      200.0, // Provide a height for the SizedBox
                                  child: Image.asset(
                                    widget.planetsLocalModal.imagePath ?? '',
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  ),
                                ),
                              ),
                              // const Positioned(
                              //   left: 100,
                              //   child: FrostedGlassBox(
                              //     theWidth: 100,
                              //     theHeight: 100,
                              //     theChild: Text(
                              //       "Hello",
                              //       style: TextStyle(color: Colors.white),
                              //     ),
                              //   ),
                              // )
                              FutureBuilder<List<PlanetsAPIModal>>(
                                future: planetsAPIModal,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    // Text(
                                    //     style: TextStyle(color: Colors.white),
                                    //     snapshot.data!
                                    //         .map((planet) => planet.temperature)
                                    //         .toString());

                                    List<PlanetsAPIModal> planets =
                                        snapshot.data!;

                                    List<num?> temperature = planets
                                        .map((planet) => planet.temperature)
                                        .toList();
                                    List<num?> mass = planets
                                        .map((planet) => planet.mass)
                                        .toList();
                                    List<num?> radius = planets
                                        .map((planet) => planet.radius)
                                        .toList();
                                    List<num?> distanceLightYear = planets
                                        .map((planet) =>
                                            planet.distanceLightYear)
                                        .toList();

                                    String tempString = temperature.join('');
                                    String massString = mass.join('');
                                    String radString = radius.join('');
                                    String distLightYearString =
                                        distanceLightYear.join('');

                                    return FrostedGlassBox(
                                      theWidth: 170,
                                      theHeight: 200,
                                      theChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Temperature: \n$tempString K",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "Mass: \n$massString Mj",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "Radius: \n$radString Rj",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "Distance: \n$distLightYearString Light Years",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          )
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    Text('${snapshot.error}');
                                  }

                                  // By default, show a loading spinner.

                                  return const CircularProgressIndicator();
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.planetsLocalModal.name.toString(),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 16.0),
                    Card(
                      color: Colors.white,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.planetsLocalModal.description.toString(),
                          textAlign: TextAlign.center,
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
    );
  }
}

// import '../Classes/planet_info.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// void main() {
//   runApp(const PlanetDescription());
// }

// class PlanetDescription extends StatefulWidget {
//   const PlanetDescription({Key? key}) : super(key: key);

//   @override
//   _PlanetDescriptionState createState() => _PlanetDescriptionState();
// }

// class _PlanetDescriptionState extends State<PlanetDescription> {
//   List<PlanetDetails> planetDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     loadPlanetDetails().then((value) {
//       setState(() {
//         planetDetails = value;
//       });
//     });
//   }

//   double angle = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: planetDetails.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : PlanetDetailsPage(
//                 planetDetails: planetDetails[0],
//                 angle: angle,
//                 onPanUpdate: (details) {
//                   setState(() {
//                     angle = math.atan2(
//                         details.localPosition.dy, details.localPosition.dx);
//                   });
//                 }),
//       ),
//     );
//   }
// }

// class PlanetDetailsPage extends StatelessWidget {
//   final PlanetDetails planetDetails;
//   final double angle;
//   final Function(DragUpdateDetails) onPanUpdate;

//   const PlanetDetailsPage(
//       {Key? key,
//       required this.planetDetails,
//       required this.angle,
//       required this.onPanUpdate})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//               image: const AssetImage("assets/images/main-bg.png"),
//               fit: BoxFit.cover,
//               colorFilter: ColorFilter.mode(
//                   Colors.grey.withOpacity(1.0), BlendMode.multiply)),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 300.0, // Provide a height for the SizedBox
//                 child: GestureDetector(
//                   onPanUpdate: onPanUpdate,
//                   child: Transform.rotate(
//                     angle: angle,
//                     child: Image.asset(
//                       planetDetails.imagePath,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//               Text(
//                 planetDetails.name.toUpperCase(),
//                 style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//               const SizedBox(height: 16.0),
//               Card(
//                 color: Colors.white,
//                 shadowColor: Colors.grey,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0)),
//                 margin: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     planetDetails.description,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

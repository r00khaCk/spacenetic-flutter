// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';
import 'package:spacenetic_flutter/Classes/planets_local_modal.dart';
import 'package:spacenetic_flutter/Functions/fetch_planetAPI.dart';
import 'package:spacenetic_flutter/StateManagement/api_cubit/SpaceApi_cubit/planet_api_cubit.dart';
// import 'package:spacenetic_flutter/StateManagement/api_cubit/SpaceApi_cubit/planet_api_cubit.dart';
import 'package:spacenetic_flutter/UI/widgets/frostedglass.dart';

class DisplayPlanetDetails extends StatelessWidget {
  const DisplayPlanetDetails({
    Key? key,
    required this.planetsLocalModal1,
  }) : super(key: key);
  final PlanetsLocalModal planetsLocalModal1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlanetApiCubit(
        FetchPlanetAPI(),
      ),
      child: PlanetDetailsPage(
        planetsLocalModal: planetsLocalModal1,
      ),
    );
  }
}

class PlanetDetailsPage extends StatefulWidget {
  final PlanetsLocalModal planetsLocalModal;
  const PlanetDetailsPage({Key? key, required this.planetsLocalModal})
      : super(key: key);

  @override
  State<PlanetDetailsPage> createState() => _PlanetDetailsPageState();
}

class _PlanetDetailsPageState extends State<PlanetDetailsPage> {
  //late Future<List<PlanetsAPIModal>> planetsAPIModal;
  //FetchPlanetAPI fetchPlanetAPI = FetchPlanetAPI();
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String? planetName = widget.planetsLocalModal.name;
      final cubit = context.read<PlanetApiCubit>();
      cubit.fetchPlanetAPI(planetName!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Center(
          child: Text(
            "Planet Info",
            style: GoogleFonts.orbitron(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/main-bg.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.grey.withOpacity(1.0), BlendMode.multiply),
          ),
        ),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 60.0),
              //   child: Row(
              //     children: [
              //       IconButton(
              //         onPressed: () {
              //           Navigator.of(context).pop();
              //         },
              //         icon: const Icon(Icons.arrow_back_ios_new),
              //         color: Colors.white,
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: SizedBox(
                  width: 400,
                  height: 200,
                  child: Row(
                    children: [
                      Spacer(),
                      Hero(
                        tag: widget.planetsLocalModal.imagePath.toString(),
                        child: SizedBox(
                          height: 150.0, // Provide a height for the SizedBox
                          child: Image.asset(
                            widget.planetsLocalModal.imagePath ?? '',
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),
                      Spacer(),
                      BlocBuilder<PlanetApiCubit, PlanetApiState>(
                          builder: (context, state) {
                        //BlocProvider.of<PlanetApiCubit>(context);
                        if (state is PlanetApiInitial ||
                            state is LoadingPlanetState) {
                          return const FrostedGlassBox(
                            theWidth: 170,
                            theHeight: 200,
                            theChild: CircularProgressIndicator(),
                          );
                        } else if (state is ResponsePlanetState) {
                          List<PlanetsAPIModal> planets = state.planetInfo;
                          List<num?> temperature = planets
                              .map((planet) => planet.temperature)
                              .toList();
                          List<num?> mass =
                              planets.map((planet) => planet.mass).toList();
                          List<num?> radius =
                              planets.map((planet) => planet.radius).toList();
                          List<num?> distanceLightYear = planets
                              .map((planet) => planet.distanceLightYear)
                              .toList();

                          String tempString = temperature.join('');
                          String massString = mass.join('');
                          String radString = radius.join('');
                          String distLightYearString =
                              distanceLightYear.join('');
                          return FrostedGlassBox(
                            theWidth: 170,
                            theHeight: 200,
                            theChild: SizedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Temperature: \n$tempString K",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    "Mass: \n$massString Mj",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    "Radius: \n$radString Rj",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    "Distance: \n$distLightYearString Light Years",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is ErrorPlanetState) {
                          return FrostedGlassBox(
                            theWidth: 170,
                            theHeight: 200,
                            theChild: Text(state.errorMessage),
                          );
                        }
                        return FrostedGlassBox(
                          theWidth: 170,
                          theHeight: 200,
                          theChild: Text(
                            state.toString(),
                          ),
                        );
                      })

                      // FutureBuilder<List<PlanetsAPIModal>>(
                      //   future: planetsAPIModal,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       // Text(
                      //       //     style: TextStyle(color: Colors.white),
                      //       //     snapshot.data!
                      //       //         .map((planet) => planet.temperature)
                      //       //         .toString());

                      //       List<PlanetsAPIModal> planets =
                      //           snapshot.data!;

                      //       List<num?> temperature = planets
                      //           .map((planet) => planet.temperature)
                      //           .toList();
                      //       List<num?> mass = planets
                      //           .map((planet) => planet.mass)
                      //           .toList();
                      //       List<num?> radius = planets
                      //           .map((planet) => planet.radius)
                      //           .toList();
                      //       List<num?> distanceLightYear = planets
                      //           .map((planet) =>
                      //               planet.distanceLightYear)
                      //           .toList();

                      //       String tempString = temperature.join('');
                      //       String massString = mass.join('');
                      //       String radString = radius.join('');
                      //       String distLightYearString =
                      //           distanceLightYear.join('');

                      //       return FrostedGlassBox(
                      //         theWidth: 170,
                      //         theHeight: 200,
                      //         theChild: Column(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceEvenly,
                      //           children: [
                      //             Text(
                      //               "Temperature: \n$tempString K",
                      //               textAlign: TextAlign.center,
                      //               style: const TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 16),
                      //             ),
                      //             Text(
                      //               "Mass: \n$massString Mj",
                      //               textAlign: TextAlign.center,
                      //               style: const TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 16),
                      //             ),
                      //             Text(
                      //               "Radius: \n$radString Rj",
                      //               textAlign: TextAlign.center,
                      //               style: const TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 16),
                      //             ),
                      //             Text(
                      //               "Distance: \n$distLightYearString Light Years",
                      //               textAlign: TextAlign.center,
                      //               style: const TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 16),
                      //             )
                      //           ],
                      //         ),
                      //       );
                      //     } else if (snapshot.hasError) {
                      //       Text('${snapshot.error}');
                      //     }

                      //     // By default, show a loading spinner.

                      //     return const CircularProgressIndicator();
                      //   },
                      // )
                    ],
                  ),
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
                        borderRadius: BorderRadius.circular(20.0),
                      ),
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

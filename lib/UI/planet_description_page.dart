import 'package:spacenetic_flutter/Classes/planets_local_modal.dart';
import 'package:flutter/material.dart';

class PlanetDetailsPage extends StatelessWidget {
  //final PlanetDetails planetDetails;
  final PlanetsLocalModal planetsLocalModal;
  const PlanetDetailsPage({Key? key, required this.planetsLocalModal})
      : super(key: key);

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
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
              SizedBox(
                height: 300.0, // Provide a height for the SizedBox
                child: Image.asset(
                  planetsLocalModal.imagePath ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                planetsLocalModal.name.toString(),
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
                    planetsLocalModal.description.toString(),
                    textAlign: TextAlign.center,
                  ),
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

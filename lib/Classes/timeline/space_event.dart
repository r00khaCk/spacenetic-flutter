// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SpaceEvent {
  final String year;
  final String eventDescription;
  final String eventImage;
  final Icon icon;
  final Color iconbackground;
  SpaceEvent({
    required this.year,
    required this.eventDescription,
    required this.eventImage,
    required this.icon,
    required this.iconbackground,
  });
}

List<SpaceEvent> spaceEvents = [
  SpaceEvent(
      year: "1957",
      eventDescription: "First satellite - Sputnik (USSR)",
      eventImage: 'assets/images/timeline_assets/Sputnik.png',
      icon: const Icon(Icons.satellite_alt),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "1958",
      eventDescription: "NASA programme established (USA)",
      eventImage: 'assets/images/timeline_assets/nasa.png',
      icon: const Icon(Icons.rocket),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "1961",
      eventDescription: "First Human in space - Yuri Gagarin (USSR)",
      eventImage: 'assets/images/timeline_assets/yuri_gagarin.png',
      icon: const Icon(Icons.person),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "1966",
      eventDescription: "First probe on Moon - Luna 9 (USSR)",
      eventImage: 'assets/images/timeline_assets/luna_9.png',
      icon: const Icon(Icons.satellite_alt),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "1969",
      eventDescription: "First humans on Moon - Apollo 11 (USA)",
      eventImage: 'assets/images/timeline_assets/apollo11.png',
      icon: const Icon(Icons.people_alt),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "1975",
      eventDescription: "First probe on Venus - Venera 7 (USSR)",
      eventImage: 'assets/images/timeline_assets/venera7.png',
      icon: const Icon(Icons.satellite_alt),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "1977",
      eventDescription: "Voyager 1 & 2 are launched (USA)",
      eventImage: 'assets/images/timeline_assets/voyager.png',
      icon: const Icon(Icons.rocket_launch_outlined),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "1981",
      eventDescription: "First resuable space shuttle (USA)",
      eventImage: 'assets/images/timeline_assets/reusable_usa.png',
      icon: const Icon(Icons.rocket_launch_outlined),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "1995",
      eventDescription: "First probe on Jupiter - Galileo (USA)",
      eventImage: 'assets/images/timeline_assets/galileo.png',
      icon: const Icon(Icons.satellite_alt),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "1998",
      eventDescription: "International Space Station (ISS)",
      eventImage: 'assets/images/timeline_assets/iss.png',
      icon: const Icon(Icons.satellite_alt),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "2014",
      eventDescription: "First soft landing on comet - Rosetta (ESA)",
      eventImage: 'assets/images/timeline_assets/rosetta.png',
      icon: const Icon(Icons.rocket_launch),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "2015",
      eventDescription: "First reusable rocket - Falcon 9 (SpaceX)",
      eventImage: 'assets/images/timeline_assets/falcon9.png',
      icon: const Icon(Icons.rocket_launch_outlined),
      iconbackground: Colors.cyan),
  SpaceEvent(
      year: "2020s",
      eventDescription: "First humans on Mars - ITS Mission (SpaceX)",
      eventImage: 'assets/images/timeline_assets/its_mission.png',
      icon: const Icon(Icons.rocket_launch_outlined),
      iconbackground: Colors.cyan),
];

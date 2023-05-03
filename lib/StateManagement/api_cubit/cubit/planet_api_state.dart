part of 'planet_api_cubit.dart';

@immutable
abstract class PlanetApiState {}

class PlanetApiInitial extends PlanetApiState {}

class LoadingPlanetState extends PlanetApiState {}

class ErrorPlanetState extends PlanetApiState {
  final String errorMessage;

  ErrorPlanetState(this.errorMessage);
}

class ResponsePlanetState extends PlanetApiState {
  final List<PlanetsAPIModal> planetInfo;
  ResponsePlanetState(this.planetInfo);
}

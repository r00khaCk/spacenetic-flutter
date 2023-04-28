part of 'planet_api_bloc.dart';

@immutable
abstract class PlanetApiState extends Equatable{}

class PlanetLoadingState extends PlanetApiState {
  @override
  List<Object?> get props => [];
}

class PlanetLoadedState extends PlanetApiState{
  final List<PlanetsAPIModal> planets;
  PlanetLoadedState(this.planets);
  @override
  List<Object?> get props => [planets];
}

class PlanetErrorState extends PlanetApiState{
  final String error;
  PlanetErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
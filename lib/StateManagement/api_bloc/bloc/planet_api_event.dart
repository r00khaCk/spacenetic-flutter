part of 'planet_api_bloc.dart';

@immutable
abstract class PlanetApiEvent extends Equatable {
  const PlanetApiEvent();
}

class LoadPlanetEvent extends PlanetApiEvent{
  @override
  List<Object?> get props => [];
}

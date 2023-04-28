import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';
import 'package:spacenetic_flutter/Functions/fetch_planetAPI.dart';

part 'planet_api_event.dart';
part 'planet_api_state.dart';

class PlanetApiBloc extends Bloc<PlanetApiEvent, PlanetApiState> {
  final FetchPlanetAPI _fetchPlanetAPI;

  PlanetApiBloc(this._fetchPlanetAPI) : super(PlanetLoadingState()) {
    on<PlanetApiEvent>((event, emit) {
      on<LoadPlanetEvent>((event, emit) async {
        emit(PlanetLoadingState());
        try {
          final planets = await _fetchPlanetAPI.getPlanetAPI();
          emit(PlanetLoadedState(planets));
        } catch (e) {
          emit(PlanetErrorState(e.toString()));
        }
      });
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';
import 'package:spacenetic_flutter/Functions/fetch_planetAPI.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'planet_api_state.dart';

class PlanetApiCubit extends Cubit<PlanetApiState> {
  final FetchPlanetAPI _fetchPlanetAPI;
  PlanetApiCubit(this._fetchPlanetAPI)
      : super(
          PlanetApiInitial(),
        );
  Future<void> fetchPlanetAPI(String name) async {
    emit(
      LoadingPlanetState(),
    );
    // String? planetName;
    try {
      final response = await _fetchPlanetAPI.getPlanetAPI(name);
      emit(
        ResponsePlanetState(response),
      );
    } catch (e) {
      String error = 'Something went wrong';
      emit(
        ErrorPlanetState(error),
      );
    }
  }
}

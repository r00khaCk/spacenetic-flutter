import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spacenetic_flutter/Classes/news_modal.dart';
import 'package:spacenetic_flutter/Functions/fetch_newsAPI.dart';

part 'news_api_state.dart';

class NewsApiCubit extends Cubit<NewsApiState> {
  final FetchNewsAPI _fetchNewsAPI;

  NewsApiCubit(this._fetchNewsAPI)
      : super(
          NewsApiInitial(),
        );

  Future<void> fetchNewsAPI() async {
    emit(
      LoadingNewsState(),
    );
    try {
      final response = await _fetchNewsAPI.getNewsAPI();
      emit(ResponseNewsState(response));
    } catch (e) {
      String error = "Something went wrong!";
      emit(ErrorNewsState(error));
    }
  }
}

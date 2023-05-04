part of 'news_api_cubit.dart';

@immutable
abstract class NewsApiState {}

class NewsApiInitial extends NewsApiState {}

class LoadingNewsState extends NewsApiState {}

class ErrorNewsState extends NewsApiState {
  final String errorMessage;

  ErrorNewsState(this.errorMessage);
}

class ResponseNewsState extends NewsApiState {
  final List<NewsModal> newsInfo;
  ResponseNewsState(this.newsInfo);
}

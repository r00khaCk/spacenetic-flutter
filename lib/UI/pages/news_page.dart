import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacenetic_flutter/Classes/news_modal.dart';
import 'package:spacenetic_flutter/Functions/fetch_newsAPI.dart';
import 'package:spacenetic_flutter/StateManagement/api_cubit/cubit/news_api_cubit.dart';
import 'package:spacenetic_flutter/UI/widgets/frostedglass.dart';

class DisplayNews extends StatelessWidget {
  const DisplayNews({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsApiCubit(
        FetchNewsAPI(),
      ),
      child: const SpaceNews(),
    );
  }
}

class SpaceNews extends StatefulWidget {
  const SpaceNews({super.key});

  @override
  State<SpaceNews> createState() => _SpaceNewsState();
}

class _SpaceNewsState extends State<SpaceNews> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final cubit = context.read<NewsApiCubit>();
        cubit.fetchNewsAPI();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("News"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/main-bg.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.grey.withOpacity(1.0), BlendMode.multiply),
          ),
        ),
        child: BlocBuilder<NewsApiCubit, NewsApiState>(
          builder: (context, state) {
            if (state is LoadingNewsState || state is NewsApiInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (state is ResponseNewsState) {
              List<NewsModal> news = state.newsInfo;
              return ListView.builder(
                padding: const EdgeInsets.all(15.0),
                itemCount: news.length,
                itemBuilder: ((context, index) {
                  final articles = news[index];
                  final title = articles.title;
                  final description = articles.summary;
                  final newsUrl = articles.newsURL;
                  final image = articles.imageURL;

                  return Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), //<-- SEE HERE
                    ),
                    child: FrostedGlassBox(
                      theHeight: 100,
                      theWidth: 100,
                      theChild: ListTile(
                        leading: SizedBox(
                          height: 200,
                          width: 150,
                          child: Image.network(
                            image!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          title!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
              );
            } else if (state is ErrorNewsState) {
              Center(
                child: Text(state.errorMessage),
              );
            }
            return Center(
              child: Text(
                state.toString(),
              ),
            );
          },
        ),
      ),
    );
  }
}

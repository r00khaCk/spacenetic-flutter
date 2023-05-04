import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spacenetic_flutter/Functions/fetch_newsAPI.dart';
import 'package:spacenetic_flutter/StateManagement/api_cubit/NewsApi_cubit/news_api_cubit.dart';
import 'package:spacenetic_flutter/UI/pages/homepage.dart';
import 'package:spacenetic_flutter/UI/pages/news_page.dart';

class MyHomeSwipeView extends StatefulWidget {
  const MyHomeSwipeView({super.key});

  @override
  State<MyHomeSwipeView> createState() => _MyHomeSwipeViewState();
}

class _MyHomeSwipeViewState extends State<MyHomeSwipeView> {
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        children: [
          HomePage(),
          BlocProvider(
            create: (_) => NewsApiCubit(
              FetchNewsAPI(),
            ),
            child: SpaceNews(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 6, 30, 66),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Color.fromARGB(255, 6, 30, 66),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(16),
            gap: 8,
            onTabChange: (index) {
              setState(() {
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.newspaper,
                text: 'News',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

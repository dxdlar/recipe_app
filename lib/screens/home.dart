import 'package:flutter/material.dart';
import 'package:recipe_app/components/bottom_nav_bar.dart';
import 'package:recipe_app/screens/home_screen.dart';
import 'package:recipe_app/screens/recipe_category.dart';
import 'package:recipe_app/screens/saved_screen.dart';
import 'package:recipe_app/screens/search_screen.dart';
import 'package:recipe_app/screens/shopping_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController pageController;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
          onTap: (index) {
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut);
            setState(() {
              currentIndex = index;
            });
          },
          SelectedItem: currentIndex),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          RecipeCategory(),
          SearchScreen(),
          SavedScreen(),
          ShoppingScreen(),
        ],
      ),
    );
  }
}

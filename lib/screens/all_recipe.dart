import 'package:flutter/material.dart';
import 'package:recipe_app/constants/constant_function.dart';
import 'package:recipe_app/screens/detail_screen.dart';

import '../components/custom_app_bar.dart';

class AllRecipe extends StatelessWidget {
  final String recipe;
  const AllRecipe({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        title: recipe,
        back: true,
      ),
      body: FutureBuilder(
        future: ConstantFunction.getResponse(recipe),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('no data'),
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              right: w * .034,
              left: w * .034,
              top: h * .03,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 10,
                  childAspectRatio: .6 / 1),
              itemBuilder: (context, index) {
                Map<String, dynamic> snap = snapshot.data![index];
                int time = snap['totalTime'].toInt();
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      item: snap,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      snap['image'],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 7,
                              left: 15,
                              child: Container(
                                height: 20,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "${time.toString()} min",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, left: 6),
                          child: Text(
                            snap['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: w * .03,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

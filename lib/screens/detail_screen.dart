import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_app/constants/share.dart';
import 'package:recipe_app/constants/show_table.dart';
import 'package:recipe_app/constants/start_cooking.dart';

import '../components/circle_button.dart';
import '../components/custom_clip_path.dart';
import '../components/ingredient_list.dart';
import '../constants/show_detail_dialog.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    var myBox = Hive.box('saved');
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    String time = widget.item['totalTime'].toString();
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: h * .44,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          widget.item['image'],
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: h * .04,
                  left: w * .05,
                  child: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: BackButton(color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * .04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    widget.item['label'],
                    style: TextStyle(
                        fontSize: w * .05,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 1),
                  Text("${time} min"),
                  SizedBox(height: h * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ShareRecipe.share(widget.item['url']);
                        },
                        child: CircleButton(
                          icon: Icons.share,
                          label: 'Share',
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: myBox.listenable(),
                        builder: (context, box, _) {
                          String key = widget.item['label'];
                          bool saved = myBox.containsKey(key);
                          if (saved) {
                            return GestureDetector(
                              onTap: () {
                                myBox.delete(key);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Recipe deleted'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: CircleButton(
                                icon: Icons.bookmark,
                                label: 'Saved',
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                myBox.put(key, key);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text('Recipe saved successfully'),
                                  ),
                                );
                              },
                              child: CircleButton(
                                icon: Icons.bookmark_border,
                                label: 'Save',
                              ),
                            );
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          ShowDialog.showCalories(
                              widget.item['totalNutrients'], context);
                        },
                        child: CircleButton(
                          icon: Icons.monitor_heart_outlined,
                          label: 'Calories',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ShowTable.showTable(context);
                        },
                        child: CircleButton(
                          icon: Icons.table_chart_outlined,
                          label: 'Unit chart',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Direction',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: w * .06),
                      ),
                      SizedBox(
                        width: w * .34,
                        child: ElevatedButton(
                          onPressed: () {
                            StartCooking.startcooking(widget.item['url']);
                          },
                          child: Text('Start'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h * .02,
                  ),
                  Container(
                    height: h * .07,
                    width: w,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipPath(
                            clipper: CustomClipPath(),
                            child: Container(
                              color: Colors.redAccent,
                              child: Center(
                                child: Text(
                                  'Ingredients Required',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: w * .05,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Text('   6\nItems'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 1.8,
                    child: IngredientList(
                      ingredients: widget.item['ingredients'],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_app/components/custom_app_bar.dart';

import '../constants/share.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    var myBox = Hive.box('saved');
    return Scaffold(
      appBar: CustomAppBar(title: 'Saved', back: false),
      body: Padding(
        padding: EdgeInsets.only(top: 10, right: 8, left: 8),
        child: ValueListenableBuilder(
          valueListenable: myBox.listenable(),
          builder: (context, box, _) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var data = box.values.toList();
                return ListTile(
                  title: Container(
                    height: h * .085,
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(data[index]),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: Text('share'),
                                value: 'share',
                              ),
                              PopupMenuItem(
                                child: Text('delete'),
                                value: 'delete',
                              )
                            ];
                          },
                          onSelected: (String value) async {
                            if (value == 'delete') {
                              deleteItem(index);
                            } else if (value == 'share') {
                              ShareRecipe.share(data[index]);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> deleteItem(int index) async {
    var myBox = Hive.box('saved');
    await myBox.deleteAt(index);
  }
}

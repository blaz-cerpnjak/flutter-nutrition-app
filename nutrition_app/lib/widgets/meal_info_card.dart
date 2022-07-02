import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nutrition_app/models/meal/meal.dart';

class MealInfoCard extends StatefulWidget {
  final Meal _meal;
  final VoidCallback _onEditPressed;

  const MealInfoCard(
    this._meal,
    this._onEditPressed,
    {Key? key}
  ) : super(key: key);

  @override
  State<MealInfoCard> createState() => _MealInfoCardState();
}

class _MealInfoCardState extends State<MealInfoCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(widget._meal.food.title),
            subtitle: Text(widget._meal.quantity.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.edit_rounded), 
              onPressed: widget._onEditPressed,
            ),
          ),
        ],
      )
    );
  }

}
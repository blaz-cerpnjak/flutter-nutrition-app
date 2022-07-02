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
    String cals = ((widget._meal.food.calories / 100) * widget._meal.quantity).toString();
    String carbs = ((widget._meal.food.carbs / 100) * widget._meal.quantity).toStringAsFixed(2);
    String protein = ((widget._meal.food.protein / 100) * widget._meal.quantity).toStringAsFixed(2);
    String fats = ((widget._meal.food.fats/ 100) * widget._meal.quantity).toStringAsFixed(2); 

    return Card(
      child: InkWell(
        onTap: widget._onEditPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget._meal.food.title,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    cals.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget._meal.quantity} g",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "C: $carbs g, P: $protein g, F: $fats g",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

}
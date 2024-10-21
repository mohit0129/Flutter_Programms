import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/meal_model.dart';

class MealController {
  List<Meal> _meals = [];

  Future<void> fetchMeals() async {
    final response = await rootBundle.loadString('assets/meals.json');
    final data = json.decode(response) as List;
    _meals = data.map((mealData) => Meal.fromJson(mealData)).toList();
  }

  List<Meal> get meals => _meals;

  List<Meal> filterMeals(bool showVeg) {
    return _meals.where((meal) => meal.isVeg == showVeg).toList();
  }

  void toggleFavorite(String id) {
    final index = _meals.indexWhere((meal) => meal.id == id);
    if (index >= 0) {
      _meals[index] = Meal(
        id: _meals[index].id,
        name: _meals[index].name,
        isVeg: _meals[index].isVeg,
        isFavorite: !_meals[index].isFavorite,
      );
    }
  }

  List<Meal> get favoriteMeals {
    return _meals.where((meal) => meal.isFavorite).toList();
  }
}

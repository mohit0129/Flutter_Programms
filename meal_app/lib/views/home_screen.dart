import 'package:flutter/material.dart';
import '../controllers/meal_controller.dart';
import '../models/meal_model.dart';
import 'meal_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MealController _mealController = MealController();
  List<Meal> _filteredMeals = [];
  bool _showFavoritesOnly = false;
  String _filterType = 'all'; // 'all', 'veg', or 'non-veg'

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    await _mealController.fetchMeals();
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      List<Meal> meals = _mealController.meals;

      // Filter meals based on veg/non-veg filter
      if (_filterType == 'veg') {
        meals = meals.where((meal) => meal.isVeg).toList();
      } else if (_filterType == 'non-veg') {
        meals = meals.where((meal) => !meal.isVeg).toList();
      }

      // If "Favorites" is enabled, filter further to show only favorite meals
      if (_showFavoritesOnly) {
        meals = meals.where((meal) => meal.isFavorite).toList();
      }

      _filteredMeals = meals;
    });
  }

  void _searchMeals(String query) {
    setState(() {
      _filteredMeals = _mealController.meals
          .where(
              (meal) => meal.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Update filter type but do not reset the favorites view
  void _toggleFilter(String filter) {
    setState(() {
      _filterType = filter;
      _applyFilters();
    });
  }

  // Toggle the favorites view and apply filters
  void _toggleFavoritesView(bool showFavorites) {
    setState(() {
      _showFavoritesOnly = showFavorites;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals App'),
        actions: [
          IconButton(
            icon: Icon(
              _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => _toggleFavoritesView(!_showFavoritesOnly),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Meals',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchMeals,
            ),
          ),
          // Filter buttons for All, Veg, and Non-Veg
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleFilter('all'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        _filterType == 'all' ? Colors.white : Colors.black,
                    backgroundColor: _filterType == 'all'
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('All'),
                ),
                ElevatedButton(
                  onPressed: () => _toggleFilter('veg'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        _filterType == 'veg' ? Colors.white : Colors.black,
                    backgroundColor: _filterType == 'veg'
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Veg'),
                ),
                ElevatedButton(
                  onPressed: () => _toggleFilter('non-veg'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        _filterType == 'non-veg' ? Colors.white : Colors.black,
                    backgroundColor: _filterType == 'non-veg'
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : const Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Non-Veg'),
                ),
              ],
            ),
          ),
          // Meal List
          Expanded(
            child: _filteredMeals.isEmpty
                ? Center(
                    child: Text(
                      _showFavoritesOnly
                          ? 'No favorite meals yet!'
                          : 'No meals found!',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredMeals.length,
                    itemBuilder: (ctx, index) {
                      return MealItem(
                        meal: _filteredMeals[index],
                        toggleFavorite: () {
                          setState(() {
                            _mealController
                                .toggleFavorite(_filteredMeals[index].id);
                            _applyFilters(); // Update filtered list if favorites change
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

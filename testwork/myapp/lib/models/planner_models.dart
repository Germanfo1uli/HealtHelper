class MealItem {
  MealItem({
    required this.name,
    required this.grams,
  });

  final String name;
  int grams;
}

enum MealType { breakfast, lunch, dinner, snacks }

extension MealTypeX on MealType {
  String get title {
    switch (this) {
      case MealType.breakfast:
        return 'Завтрак';
      case MealType.lunch:
        return 'Обед';
      case MealType.dinner:
        return 'Ужин';
      case MealType.snacks:
        return 'Перекусы';
    }
  }
}

class ShoppingItem {
  ShoppingItem({
    required this.name,
    this.isBought = false,
  });

  final String name;
  bool isBought;
}

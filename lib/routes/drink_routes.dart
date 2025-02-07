import 'package:dart_backend/controller/drink_controller.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf_router/shelf_router.dart';

class DrinkRoutes {
  final MySqlConnection connection;

  DrinkRoutes(this.connection);

  Router get router {
    final router = Router();
    final drinkController = DrinkController(connection);

    router.get('/all', drinkController.getAllDrinks); // GET /all
    router.get(
        '/get', drinkController.getDrinksByCategory); // GET /get?category_id
    router.get(
        '/user',
        drinkController
            .getDrinksByCategoryUser); // GET /user?user_id,category_id

    return router;
  }
}

import 'package:dart_backend/controller/category_controller.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql1/mysql1.dart';

class CategoryRoutes {
  final MySqlConnection connection;

  CategoryRoutes(this.connection);

  Router get router {
    final router = Router();
    final categoryController = CategoryController(connection);

    router.get('/all', categoryController.getAllCategories); // GET /all

    return router;
  }
}

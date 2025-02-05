import 'package:dart_backend/routes/user_routes.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AppRoutes {
  final MySqlConnection connection;
  AppRoutes(this.connection);

  Router get router {
    final app = Router();

    // API GET /
    app.get('/', (Request request) {
      return Response.ok('{"message": "Hello from Dart Shelf!"}',
          headers: {'Content-Type': 'application/json'});
    });

    // Include User Routes
    app.mount('/api/user', UserRoutes(connection).router.call);

    return app;
  }
}

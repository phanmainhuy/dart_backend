import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AppRoutes {
  Router get router {
    final app = Router();

    // API GET /
    app.get('/', (Request request) {
      return Response.ok('{"message": "Hello from Dart Shelf!"}',
          headers: {'Content-Type': 'application/json'});
    });

    return app;
  }
}

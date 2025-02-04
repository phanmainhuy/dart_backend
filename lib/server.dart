import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final app = Router();

  // API GET /
  app.get('/', (Request request) {
    return Response.ok('{"message": "Hello from Dart Shelf!"}',
        headers: {'Content-Type': 'application/json'});
  });

  // 404 Error
  var handler = Pipeline().addMiddleware(logRequests()).addHandler(app.call);

  var server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('🚀 Server running on http://${server.address.host}:${server.port}');
}

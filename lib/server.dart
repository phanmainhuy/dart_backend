import 'dart:io';
import 'package:dart_backend/configs/connect.dart';
import 'package:dart_backend/routes/routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  final connection = await connectToDatabase();
  final appRoutes = AppRoutes(connection);

  // Middleware + Handler
  var handler =
      Pipeline().addMiddleware(logRequests()).addHandler(appRoutes.router);

  var server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('🚀 Server running on http://${server.address.host}:${server.port}');
}

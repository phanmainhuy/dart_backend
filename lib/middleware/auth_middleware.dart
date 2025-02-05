import 'package:dart_backend/constants/api_response.dart';
import 'package:shelf/shelf.dart';
import '../helpers/jwt_helper.dart';

class AuthMiddleware {
  static Future<Response> protectedRoute(
      Request request, Future<Response> Function(Request) handler) async {
    final authHeader = request.headers['Authorization'];

    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return ApiResponse.error(
        statusCode: 401,
        message: 'Missing or invalid Authorization header',
      );
    }

    final token = authHeader.substring(7); // Remove 'Bearer ' prefix
    final decodedToken = JwtHelper.verifyJwt(token);

    if (decodedToken == null) {
      return ApiResponse.error(
        statusCode: 401,
        message: 'Invalid or expired token',
      );
    }

    // If token is valid, proceed to the requested route
    return handler(request);
  }
}

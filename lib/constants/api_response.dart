import 'dart:convert';
import 'package:dart_backend/constants/const.dart';
import 'package:shelf/shelf.dart';

class ApiResponse {
  final String? message;
  final dynamic data;

  ApiResponse({this.message, this.data});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  @override
  String toString() => jsonEncode(toJson());

  static Response ok({
    String? message,
    dynamic data,
    Map<String, String> headers = jsonHeaders,
  }) {
    return Response.ok(
      jsonEncode(
        data,
      ),
      headers: headers,
    );
  }

  static Response error({
    int statusCode = 500,
    String? message,
    Map<String, String> headers = jsonHeaders,
  }) {
    switch (statusCode) {
      case 500:
        return Response.internalServerError(
          body: jsonEncode(
            {'error': '$message'},
          ),
          headers: jsonHeaders,
        );

      default:
        return Response(
          statusCode,
          body: jsonEncode(ApiResponse(
            message: message,
          ).toJson()),
          headers: headers,
        );
    }
  }
}

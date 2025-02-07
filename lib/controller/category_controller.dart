import 'package:dart_backend/constants/api_response.dart';
import 'package:dart_backend/models/category_model.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

class CategoryController {
  final MySqlConnection connection;

  CategoryController(this.connection);

  Future<Response> getAllCategories(Request request) async {
    try {
      var results = await connection.query(
          'SELECT id, name, icon_url FROM category WHERE deleted IS NULL');

      List<CategoryModel> categories =
          results.map((row) => CategoryModel.fromRow(row)).toList();

      return ApiResponse.ok(
        data: categories.map((category) {
          Map<String, dynamic> categoryMap = category.toJson();
          return categoryMap;
        }).toList(),
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }
}

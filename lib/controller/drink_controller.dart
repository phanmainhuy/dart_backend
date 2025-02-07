import 'package:dart_backend/constants/api_response.dart';
import 'package:dart_backend/models/drink_model.dart';
import 'package:dart_backend/models/drink_user_model.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

class DrinkController {
  final MySqlConnection connection;

  DrinkController(this.connection);

  Future<Response> getAllDrinks(Request request) async {
    try {
      var results = await connection.query("""
              SELECT id, name, price, category_id, icon_url FROM drink WHERE deleted IS NULL 
              ORDER BY category_id ASC
          """);

      List<DrinkModel> drinks =
          results.map((row) => DrinkModel.fromRow(row)).toList();

      return ApiResponse.ok(
        data: drinks.map((drink) {
          Map<String, dynamic> drinkMap = drink.toJson();
          return drinkMap;
        }).toList(),
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }

  Future<Response> getDrinksByCategory(Request request) async {
    try {
      var queryParams = request.url.queryParameters;
      final int categoryID = int.parse(queryParams['category_id'] ?? '0');

      var result = await connection.query("""
              SELECT id, name, price, category_id, icon_url FROM drink 
              WHERE deleted IS NULL 
              AND category_id = ?
              ORDER BY name ASC
          """, [categoryID]);

      List<DrinkModel> drinks =
          result.map((row) => DrinkModel.fromRow(row)).toList();

      return ApiResponse.ok(
        data: drinks.map((drink) {
          Map<String, dynamic> drinkMap = drink.toJson();
          return drinkMap;
        }).toList(),
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }

  Future<Response> getDrinksByCategoryUser(Request request) async {
    try {
      var queryParams = request.url.queryParameters;
      final int categoryID = int.parse(queryParams['category_id'] ?? '0');
      final int userID = int.parse(queryParams['user_id'] ?? '0');

      var result = await connection.query("""
              SELECT 
                  d.id, 
                  d.name, 
                  d.price, 
                  d.category_id, 
                  d.icon_url, 
                  COALESCE(cd.quantity, 0) AS cart_quantity
              FROM drink d
              LEFT JOIN cart c 
                  ON c.user_id = ? 
                  AND c.status = 'PENDING' -- Join with the user's pending cart
              LEFT JOIN cart_detail cd 
                  ON d.id = cd.drink_id 
                  AND cd.cart_id = c.id -- Match drinks in the user's cart
              WHERE d.deleted IS NULL 
                AND d.category_id = ?
              ORDER BY d.name ASC;
          """, [userID, categoryID]);

      List<DrinkUserModel> drinks =
          result.map((row) => DrinkUserModel.fromRow(row)).toList();

      return ApiResponse.ok(
        data: drinks.map((drink) {
          Map<String, dynamic> drinkMap = drink.toJson();
          return drinkMap;
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

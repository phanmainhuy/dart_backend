import 'dart:convert';

import 'package:dart_backend/constants/api_response.dart';
import 'package:dart_backend/models/cart_model.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

class CartController {
  final MySqlConnection connection;

  CartController(this.connection);

  Future<Response> getCartByUserID(Request request) async {
    try {
      double totalPrice = 0;
      int totalQuantity = 0;
      var queryParams = request.url.queryParameters;
      final int userID = int.parse(queryParams['user_id'] ?? '0');

      var results = await connection.query("""
          SELECT
            c.id AS cart_id,
            cd.drink_id,
            d.name AS drink_name,
            cd.quantity,
            cd.price,
            (cd.quantity * cd.price) AS total_price,
            c.user_id,
            d.icon_url
          FROM cart c
            JOIN cart_detail cd ON c.id = cd.cart_id
            JOIN drink d ON cd.drink_id = d.id
            JOIN user u ON c.user_id = u.id
          WHERE c.user_id = ? 
              AND c.status = 'PENDING'
              AND u.deleted IS NULL
          """, [userID]);

      List<CartModel> carts =
          results.map((row) => CartModel.fromRow(row)).toList();

      for (int i = 0; i < carts.length; i++) {
        totalPrice += carts[i].totalPrice;
        totalQuantity += carts[i].quantity;
      }

      return ApiResponse.ok(
        data: {
          'total_price': totalPrice,
          'total_quantity': totalQuantity,
          'data': carts.map((cart) {
            Map<String, dynamic> cartMap = cart.toJson();
            return cartMap;
          }).toList()
        },
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }

  Future<Response> updateDrinkQuantity(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());

      final int userID = payload['user_id'];
      final int cartID = payload['cart_id'];
      final int drinkID = payload['drink_id'];
      final int quantity = payload['quantity'];

      // Check if cart_detail exists
      var existCart = await connection.query(
        'SELECT id FROM cart_detail WHERE cart_id = ? AND drink_id = ?',
        [cartID, drinkID],
      );

      if (existCart.isEmpty) {
        return ApiResponse.error(
          statusCode: 404,
          message: 'Item not found',
        );
      }

      if (quantity <= 1) {
        // DELETE the cart_detail if quantity is 0 or less
        await connection.query("""
        DELETE cd
        FROM cart_detail cd
        JOIN cart c ON cd.cart_id = c.id
        WHERE cd.cart_id = ? AND cd.drink_id = ? AND c.user_id = ?
      """, [cartID, drinkID, userID]);

        // Recalculate the cart details
        var updatedResults = await connection.query("""
        SELECT
          c.id AS cart_id,
          cd.drink_id,
          d.name AS drink_name,
          cd.quantity,
          cd.price,
          (cd.quantity * cd.price) AS total_price,
          c.user_id,
          d.icon_url
        FROM cart c
          JOIN cart_detail cd ON c.id = cd.cart_id
          JOIN drink d ON cd.drink_id = d.id
          JOIN user u ON c.user_id = u.id
        WHERE c.user_id = ? 
            AND c.status = 'PENDING'
            AND u.deleted IS NULL
      """, [userID]);

        List<CartModel> carts =
            updatedResults.map((row) => CartModel.fromRow(row)).toList();
        double totalPrice = 0;
        int totalQuantity = 0;
        for (int i = 0; i < carts.length; i++) {
          totalPrice += carts[i].totalPrice;
          totalQuantity += carts[i].quantity;
        }

        return ApiResponse.ok(
          data: {
            'total_price': totalPrice,
            'total_quantity': totalQuantity,
            'data': carts.map((cart) => cart.toJson()).toList(),
          },
        );
      } else {
        // Update the quantity if quantity > 0
        var resultUpdate = await connection.query("""
        UPDATE cart_detail
        SET quantity = ?
        WHERE cart_id = ? AND drink_id = ?
      """, [quantity, cartID, drinkID]);

        if (resultUpdate.affectedRows == 0) {
          return ApiResponse.error(
            statusCode: 500,
            message: 'Update failed',
          );
        }

        // Recalculate the cart details
        var updatedResults = await connection.query("""
        SELECT
          c.id AS cart_id,
          cd.drink_id,
          d.name AS drink_name,
          cd.quantity,
          cd.price,
          (cd.quantity * cd.price) AS total_price,
          c.user_id,
          d.icon_url
        FROM cart c
          JOIN cart_detail cd ON c.id = cd.cart_id
          JOIN drink d ON cd.drink_id = d.id
          JOIN user u ON c.user_id = u.id
        WHERE c.user_id = ? 
            AND c.status = 'PENDING'
            AND u.deleted IS NULL
      """, [userID]);

        List<CartModel> carts =
            updatedResults.map((row) => CartModel.fromRow(row)).toList();
        double totalPrice = 0;
        int totalQuantity = 0;
        for (int i = 0; i < carts.length; i++) {
          totalPrice += carts[i].totalPrice;
          totalQuantity += carts[i].quantity;
        }

        return ApiResponse.ok(
          data: {
            'total_price': totalPrice,
            'total_quantity': totalQuantity,
            'data': carts.map((cart) => cart.toJson()).toList(),
          },
        );
      }
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }

  Future<Response> updateCheckoutCart(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());

      final int cartID = payload['cart_id'];

      // Check exists
      var existCart = await connection.query(
        'SELECT id FROM cart_detail WHERE cart_id = ?',
        [cartID],
      );

      if (existCart.isEmpty) {
        return ApiResponse.error(
          statusCode: 404,
          message: 'Item not found',
        );
      }

      await connection.query("""
          UPDATE cart
          SET status = 'CHECK_OUT'
          WHERE id = ?;
      """, [cartID]);
      return ApiResponse.ok(
        data: {},
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }

  Future<Response> deleteCartItem(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());

      final int cartID = payload['cart_id'];
      final int userID = payload['user_id'];
      final int drinkID = payload['drink_id'];

      // Check exists
      var existCart = await connection.query(
        'SELECT id FROM cart_detail WHERE cart_id = ?',
        [cartID],
      );

      if (existCart.isEmpty) {
        return ApiResponse.error(
          statusCode: 404,
          message: 'Item not found',
        );
      }

      await connection.query("""
          DELETE cd
          FROM cart_detail cd
          JOIN cart c ON cd.cart_id = c.id
          WHERE cd.cart_id = ? AND cd.drink_id = ? AND c.user_id = ?
      """, [cartID, drinkID, userID]);
      return ApiResponse.ok(
        data: {},
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }

  Future<Response> createOrUpdateCart(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());

      final int userID = payload['user_id'];
      final List<dynamic> cartDetails =
          payload['cart_details']; // List of cart detail items

      if (cartDetails.isEmpty) {
        return ApiResponse.error(
          statusCode: 400,
          message: 'Cart details cannot be empty',
        );
      }

      // Check if a pending cart already exists for the user
      var existingCart = await connection.query("""
      SELECT id FROM cart WHERE user_id = ? AND status = 'PENDING';
    """, [userID]);

      int? cartID;
      if (existingCart.isNotEmpty) {
        // Get the existing cart ID
        cartID = existingCart.first['id'];

        // Update or insert cart details
        for (var detail in cartDetails) {
          final int drinkID = detail['drink_id'];
          final int quantity = detail['quantity'];
          final double price = detail['price'];

          // Check if the cart_detail exists
          var existingDetail = await connection.query("""
          SELECT id FROM cart_detail WHERE cart_id = ? AND drink_id = ?;
        """, [cartID, drinkID]);

          if (existingDetail.isNotEmpty) {
            // Update existing cart_detail
            await connection.query("""
            UPDATE cart_detail
            SET quantity = quantity + ?, price = ?
            WHERE cart_id = ? AND drink_id = ?;
          """, [quantity, price, cartID, drinkID]);
          } else {
            // Insert new cart_detail
            await connection.query("""
            INSERT INTO cart_detail (cart_id, drink_id, quantity, price)
            VALUES (?, ?, ?, ?);
          """, [cartID, drinkID, quantity, price]);
          }
        }
      } else {
        // Create a new cart
        var result = await connection.query("""
        INSERT INTO cart (user_id, status)
        VALUES (?, 'PENDING');
      """, [userID]);

        // Get the newly inserted cart ID
        cartID = result.insertId;

        // Insert cart details
        for (var detail in cartDetails) {
          final int drinkID = detail['drink_id'];
          final int quantity = detail['quantity'];
          final double price = detail['price'];

          await connection.query("""
          INSERT INTO cart_detail (cart_id, drink_id, quantity, price)
          VALUES (?, ?, ?, ?);
        """, [cartID, drinkID, quantity, price]);
        }
      }

      double totalPrice = 0;
      int totalQuantity = 0;

      // Calculate the updated cart summary
      var cartDetailsResult = await connection.query("""
      SELECT
          c.id AS cart_id,
          cd.drink_id,
          d.name AS drink_name,
          cd.quantity,
          cd.price,
          (cd.quantity * cd.price) AS total_price,
          c.user_id,
          d.icon_url
      FROM cart c
        JOIN cart_detail cd ON c.id = cd.cart_id
        JOIN drink d ON cd.drink_id = d.id
        JOIN user u ON c.user_id = u.id
      WHERE c.id = ? 
        AND c.status = 'PENDING'
        AND u.deleted IS NULL;
    """, [cartID]);

      List<CartModel> cartItems =
          cartDetailsResult.map((row) => CartModel.fromRow(row)).toList();

      for (int i = 0; i < cartItems.length; i++) {
        totalPrice += cartItems[i].totalPrice;
        totalQuantity += cartItems[i].quantity;
      }

      return ApiResponse.ok(
        data: {
          'cart_id': cartID,
          'total_price': totalPrice,
          'total_quantity': totalQuantity,
          'cart_details': cartItems.map((item) => item.toJson()).toList(),
        },
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }
}

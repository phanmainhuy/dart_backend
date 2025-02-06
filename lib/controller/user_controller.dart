import 'package:dart_backend/helpers/jwt_helper.dart';
import 'package:dart_backend/constants/api_response.dart';
import 'package:dart_backend/constants/const.dart';
import 'package:dart_backend/helpers/password_helper.dart';
import 'package:dart_backend/models/user_model.dart';
import 'package:shelf/shelf.dart';
import 'package:mysql1/mysql1.dart';

import 'dart:convert';

class UserController {
  final MySqlConnection connection;

  UserController(this.connection);

  Future<Response> getUsers(Request request) async {
    try {
      var results = await connection.query(
          'SELECT id, role, name, mobile, email, birthday, gender, address, avatar, password FROM user WHERE deleted IS NULL');

      List<UserModel> users =
          results.map((row) => UserModel.fromRow(row)).toList();

      return ApiResponse.ok(
        data: users.map((user) {
          Map<String, dynamic> userMap = user.toJson();
          userMap.remove('password'); // Remove password key
          return userMap;
        }).toList(),
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }

  Future<Response> getUserByEmail(Request request) async {
    try {
      // Get query parameters
      var queryParams = request.url.queryParameters;
      String? email = queryParams['email'];

      if (email == null) {
        return ApiResponse.error(
          statusCode: 400,
          message: 'Missing email parameter',
        );
      }

      var result = await connection.query(
        'SELECT id, role, name, mobile, email, birthday, gender, address, avatar, password FROM user WHERE email = ? AND deleted IS NULL',
        [email],
      );

      if (result.isEmpty) {
        return ApiResponse.error(
          statusCode: 404,
          message: 'User not found',
        );
      }

      UserModel user = UserModel.fromRow(result.first);

      // Convert to JSON and remove the password
      Map<String, dynamic> userMap = user.toJson();
      userMap.remove('password');

      return ApiResponse.ok(
        data: userMap,
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: 'Server error: $e',
      );
    }
  }

  Future<Response> login(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());

      final String email = payload['email'];
      final String password = payload['password'];

      var result = await connection.query(
          'SELECT id, role, name, mobile, email, birthday, gender, address, avatar, password FROM user WHERE email = ? AND deleted IS NULL',
          [email]);

      if (result.isEmpty) {
        return ApiResponse.error(
          statusCode: 400,
          message: 'Invalid email or password',
        );
      }

      var row = result.first;
      UserModel user = UserModel.fromRow(row);

      // Check password
      if (!PasswordHelper.verifyPassword(
        password: password,
        hashedPassword: user.password,
      )) {
        return ApiResponse.error(
          message: 'Invalid email or password',
          statusCode: 400,
          headers: jsonHeaders,
        );
      }

      Map<String, dynamic> response = user.toJson();
      // remove password
      response.remove('password');

      // Add a fake JWT token
      response['token'] = JwtHelper.generateJwt(
        userId: user.id.toString(),
        role: user.role.toString(),
      );

      return ApiResponse.ok(
        data: response,
        headers: jsonHeaders,
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }

  Future<Response> register(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());

      final String name = payload['name'];
      final String email = payload['email'];
      final String password = payload['password'];
      final String mobile = payload['mobile'];

      // Check if email already exists
      var existingUser = await connection.query(
        'SELECT id FROM user WHERE email = ? AND deleted IS NULL',
        [email],
      );

      if (existingUser.isNotEmpty) {
        return ApiResponse.error(
          statusCode: 400,
          message: 'Email already existed',
        );
      }

      // Hash password before saving
      String hashedPassword = PasswordHelper.hashPassword(password);

      // Insert new user
      var result = await connection.query(
        '''INSERT INTO user (name, email, password, mobile) 
          VALUES (?, ?, ?, ?)
        ''',
        [
          name,
          email,
          hashedPassword,
          mobile,
        ],
      );

      if (result.affectedRows == 0) {
        return ApiResponse.error(
          statusCode: 500,
          message: 'User registration failed',
        );
      }
      // Retrieve the inserted user
      var newUser = await connection.query(
        'SELECT id, role, name, mobile, email, birthday, gender, address, avatar, password FROM user WHERE email = ?',
        [email],
      );

      if (newUser.isEmpty) {
        return ApiResponse.error(
          statusCode: 500,
          message: 'Error fetching registered user',
        );
      }

      UserModel user = UserModel.fromRow(newUser.first);

      Map<String, dynamic> response = user.toJson();

      // Remove password before returning data
      response.remove('password');

      return ApiResponse.ok(
        data: response,
        headers: jsonHeaders,
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: 'Server error: $e',
      );
    }
  }

  Future<Response> updateUser(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());

      final String name = payload['name'];
      final String email = payload['email'];
      final String? password = payload['password']; // Password is optional
      final String mobile = payload['mobile'];

      // Check if the user exists
      var existingUser = await connection.query(
        'SELECT id FROM user WHERE email = ? AND deleted IS NULL',
        [email],
      );

      if (existingUser.isEmpty) {
        return ApiResponse.error(
          statusCode: 404,
          message: 'User not found',
        );
      }

      final int userId = existingUser.first[0];

      // Prepare update fields
      List<dynamic> updateValues = [
        name,
        email,
        mobile,
      ];
      String updateQuery = '''
        UPDATE user SET name = ?, email = ?, mobile = ? 
      ''';

      // If password is provided, hash it and update
      if (password != null && password.isNotEmpty) {
        String hashedPassword = PasswordHelper.hashPassword(password);
        updateQuery += ', password = ?';
        updateValues.add(hashedPassword);
      }

      updateQuery += ' WHERE id = ?';
      updateValues.add(userId);

      // Execute the update query
      var result = await connection.query(updateQuery, updateValues);

      // if (result.affectedRows == 0) {
      //   return ApiResponse.error(
      //     statusCode: 500,
      //     message: 'User update failed',
      //   );
      // }

      // Retrieve updated user
      var updatedUser = await connection.query(
        'SELECT id, role, name, mobile, email, birthday, gender, address, avatar, password FROM user WHERE email = ?',
        [email],
      );

      if (updatedUser.isEmpty) {
        return ApiResponse.error(
          statusCode: 500,
          message: 'Error fetching updated user',
        );
      }

      UserModel user = UserModel.fromRow(updatedUser.first);
      Map<String, dynamic> response = user.toJson();

      // Remove password before returning data
      response.remove('password');

      return ApiResponse.ok(
        data: response,
        headers: jsonHeaders,
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: 'Server error: $e',
      );
    }
  }

  Future<Response> deleteUser(Request request) async {
    try {
      bool deleteStatus = false;
      final payload = jsonDecode(await request.readAsString());

      final String userID = payload['user_id'];

      var result = await connection.query(
        '''
          UPDATE user SET deleted = 1 
          WHERE id = ?
        ''',
        [userID],
      );

      if (result.affectedRows != 0) {
        deleteStatus = true;
      }

      if (!deleteStatus) {
        return ApiResponse.error(
          statusCode: 400,
          message: 'Delete user failed',
        );
      }

      Map<String, dynamic> response = {
        'user_id': userID,
        'status': deleteStatus,
      };

      return ApiResponse.ok(
        data: response,
        headers: jsonHeaders,
      );
    } catch (e) {
      return ApiResponse.error(
        statusCode: 500,
        message: '$e',
      );
    }
  }
}

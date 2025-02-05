import 'package:bcrypt/bcrypt.dart';

class PasswordHelper {
  // Hash a password
  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  // Verify a password against a hash
  static bool verifyPassword({String? password, String? hashedPassword}) {
    if (hashedPassword == '' ||
        hashedPassword == null ||
        password == '' ||
        password == null) {
      return false;
    }
    return BCrypt.checkpw(password, hashedPassword);
  }
}

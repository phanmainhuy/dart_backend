import 'package:dart_backend/constants/jwt_config.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  // Generate JWT Token
  static String generateJwt({required String userId, required String role}) {
    final claimSet = JwtClaim(
      subject: userId,
      issuer: 'asdasd',
      otherClaims: {'role': role},
      issuedAt: DateTime.now(),
      maxAge: const Duration(hours: 1), // Token expires in 1 hour
    );

    return issueJwtHS256(claimSet, JWTConfig.secret);
  }

  // Verify and Decode JWT Token
  static JwtClaim? verifyJwt(String token) {
    try {
      return verifyJwtHS256Signature(token, JWTConfig.secret);
    } catch (e) {
      return null; // Token invalid or expired
    }
  }
}

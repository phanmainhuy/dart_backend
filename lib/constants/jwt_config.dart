import 'package:dotenv/dotenv.dart';

class JWTConfig {
  static final _env = DotEnv()..load();

  static String issuer = _env['JWT_ISSUER'] ?? 'your_secret_issuer';
  static String secret = _env['JWT_SECRET'] ?? 'your_secret_key';
}

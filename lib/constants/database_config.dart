import 'package:dotenv/dotenv.dart';

class DatabaseConfig {
  static final _env = DotEnv()..load();

  static String host = _env['DB_HOST'] ?? 'localhost';
  static int port = int.tryParse(_env['DB_PORT'] ?? '3306') ?? 3306;
  static String user = _env['DB_USER'] ?? 'root';
  static String password = _env['DB_PASSWORD'] ?? '';
  static String dbName = _env['DB_NAME'] ?? 'testdb';
}

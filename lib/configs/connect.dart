import 'package:dart_backend/constants/database_config.dart';
import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> connectToDatabase() async {
  final settings = ConnectionSettings(
    host: DatabaseConfig.host,
    port: DatabaseConfig.port,
    user: DatabaseConfig.user,
    password: DatabaseConfig.password,
    db: DatabaseConfig.dbName,
  );

  return await MySqlConnection.connect(settings);
}

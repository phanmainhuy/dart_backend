import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> connectToDatabase() async {
  final settings = ConnectionSettings(
    host: 'your-database-host',
    port: 3306,
    user: 'your-username',
    password: 'your-password',
    db: 'your-database-name',
  );

  return await MySqlConnection.connect(settings);
}

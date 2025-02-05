import 'package:dart_backend/controller/user_controller.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql1/mysql1.dart';

class UserRoutes {
  final MySqlConnection connection;

  UserRoutes(this.connection);

  Router get router {
    final router = Router();
    final userController = UserController(connection);

    router.get('/all', userController.getUsers); // GET /all
    router.get('/person', userController.getUserByEmail); // GET /user?email=x
    router.post('/login', userController.login); // POST /login
    router.post('/register', userController.register); // POST /register
    router.put('/update', userController.updateUser); // POST /register
    router.delete('/delete', userController.deleteUser); // POST /delete

    return router;
  }
}

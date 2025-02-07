import 'package:dart_backend/controller/cart_controller.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql1/mysql1.dart';

class CartRoutes {
  final MySqlConnection connection;

  CartRoutes(this.connection);

  Router get router {
    final router = Router();
    final cartController = CartController(connection);

    router.get('/get', cartController.getCartByUserID); // GET /get?user_id=
    router.put('/update', cartController.updateDrinkQuantity); // PUT /update
    router.post(
        '/checkout', cartController.updateCheckoutCart); // POST /checkout
    router.delete('/delete', cartController.deleteCartItem); // DELETE /delete
    router.post('/add', cartController.createOrUpdateCart); // POST /add

    return router;
  }
}

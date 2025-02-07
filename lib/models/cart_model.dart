import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  @JsonKey(name: 'cart_id')
  final int cartId;

  @JsonKey(name: 'drink_id')
  final int drinkId;

  @JsonKey(name: 'drink_name')
  final String drinkName;

  final int quantity;

  final double price;

  @JsonKey(name: 'total_price')
  final double totalPrice;

  @JsonKey(name: 'user_id')
  final int userId;

  final String? iconUrl;

  CartModel({
    required this.cartId,
    required this.drinkId,
    required this.drinkName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.userId,
    this.iconUrl,
  });

  // Convert from database row to model
  factory CartModel.fromRow(List<dynamic> row) {
    return CartModel(
      cartId: row[0] as int,
      drinkId: row[1] as int,
      drinkName: row[2] as String,
      quantity: row[3] as int,
      price: (row[4] as num).toDouble(),
      totalPrice: (row[5] as num).toDouble(),
      userId: row[6] as int,
      iconUrl: row[7] as String,
    );
  }

  // Auto-generate fromJson & toJson
  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'drink_user_model.g.dart';

@JsonSerializable()
class DrinkUserModel {
  @JsonKey(name: 'id')
  final int id;
  final String name;
  final double price;
  @JsonKey(name: 'category_id')
  final int categoryId;
  final String? iconUrl;
  @JsonKey(name: 'cart_quantity')
  final int cartQuantity;

  DrinkUserModel({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    this.iconUrl,
    required this.cartQuantity,
  });

  // Convert from database row to model
  factory DrinkUserModel.fromRow(List<dynamic> row) {
    return DrinkUserModel(
      id: row[0] as int,
      name: row[1] as String,
      price: row[2] as double,
      categoryId: row[3] as int,
      iconUrl: row[4] as String?,
      cartQuantity: row[5] as int,
    );
  }

  // Auto-generate fromJson & toJson
  factory DrinkUserModel.fromJson(Map<String, dynamic> json) =>
      _$DrinkUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkUserModelToJson(this);
}

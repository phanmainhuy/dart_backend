import 'package:json_annotation/json_annotation.dart';

part 'drink_model.g.dart';

@JsonSerializable()
class DrinkModel {
  @JsonKey(name: 'id')
  final int id;
  final String name;
  final double price;
  @JsonKey(name: 'category_id')
  final int categoryId;
  final String? iconUrl;

  DrinkModel({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    this.iconUrl,
  });

  // Convert from database row to model
  factory DrinkModel.fromRow(List<dynamic> row) {
    return DrinkModel(
      id: row[0] as int,
      name: row[1] as String,
      price: row[2] as double,
      categoryId: row[3] as int,
      iconUrl: row[4] as String?,
    );
  }

  // Auto-generate fromJson & toJson
  factory DrinkModel.fromJson(Map<String, dynamic> json) =>
      _$DrinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkModelToJson(this);
}

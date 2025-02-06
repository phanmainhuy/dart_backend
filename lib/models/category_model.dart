import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: 'id')
  final int id;
  final String name;
  final String iconUrl;
  final bool? deleted;
  final DateTime? deletedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.deleted,
    this.deletedAt,
  });

  // Convert from database row to model
  factory CategoryModel.fromRow(List<dynamic> row) {
    return CategoryModel(
      id: row[0] as int,
      name: row[1] as String,
      iconUrl: row[2] as String,
      deleted: row[3] == null ? null : (row[3] as int) == 1,
      deletedAt: row[4] != null ? DateTime.tryParse(row[4].toString()) : null,
    );
  }

  // Auto-generate fromJson & toJson
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

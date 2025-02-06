// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkModel _$DrinkModelFromJson(Map<String, dynamic> json) => DrinkModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['category_id'] as num).toInt(),
      iconUrl: json['iconUrl'] as String?,
      deleted: json['deleted'] as bool?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$DrinkModelToJson(DrinkModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'category_id': instance.categoryId,
      'iconUrl': instance.iconUrl,
      'deleted': instance.deleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

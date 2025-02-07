// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkUserModel _$DrinkUserModelFromJson(Map<String, dynamic> json) =>
    DrinkUserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['category_id'] as num).toInt(),
      iconUrl: json['iconUrl'] as String?,
      cartQuantity: (json['cart_quantity'] as num).toInt(),
    );

Map<String, dynamic> _$DrinkUserModelToJson(DrinkUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'category_id': instance.categoryId,
      'iconUrl': instance.iconUrl,
      'cart_quantity': instance.cartQuantity,
    };

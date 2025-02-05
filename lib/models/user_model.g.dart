// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      idUser: (json['id_user'] as num).toInt(),
      role: (json['role'] as num).toInt(),
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      birthday: json['birthday'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      avatar: json['avatar'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id_user': instance.idUser,
      'role': instance.role,
      'name': instance.name,
      'mobile': instance.mobile,
      'email': instance.email,
      'birthday': instance.birthday,
      'gender': instance.gender,
      'address': instance.address,
      'avatar': instance.avatar,
      'password': instance.password,
    };

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'id')
  final int id;
  final int role;
  final String? name;
  final String? mobile;
  final String? email;
  final String? birthday;
  final String? gender;
  final String? address;
  final String? avatar;
  final String? password;

  UserModel({
    required this.id,
    required this.role,
    this.name,
    this.mobile,
    this.email,
    this.birthday,
    this.gender,
    this.address,
    this.avatar,
    this.password,
  });

  // Convert from database row to model
  factory UserModel.fromRow(List<dynamic> row) {
    return UserModel(
      id: row[0] as int,
      role: row[1] as int,
      name: row[2] as String?,
      mobile: row[3] as String?,
      email: row[4] as String?,
      birthday: row[5]?.toString(),
      gender: row[6] as String?,
      address: row[7] as String?,
      avatar: row[8] as String?,
      password: row[9] as String?,
    );
  }

  // Auto-generate fromJson & toJson
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

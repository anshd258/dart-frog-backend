import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({required this.email, this.name, required this.password, this.phone});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  String? name;
  String email;
  String? phone;
  String password;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

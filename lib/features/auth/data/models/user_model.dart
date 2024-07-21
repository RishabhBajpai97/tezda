import 'package:tezda/core/shared/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.email, required super.name});
  factory UserModel.fromJSON(Map<String, dynamic> map) {
    return UserModel(
        id: map["id"] ?? "",
        email: map["email"] ?? "",
        name: map["name"] ?? "");
  }
  @override
  String toString() {
    return "Id:$id, Name:$name, Email:$email";
  }

  UserModel copyWith({String? id, String? name, String? email}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}

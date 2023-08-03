import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_auth/features/user/domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String name;

  UserModel({required this.id, required this.email, required this.name});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email!,
      name: user.displayName!,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
    );
  }
}

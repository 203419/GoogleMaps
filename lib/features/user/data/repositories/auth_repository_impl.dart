import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';
import 'package:app_auth/features/user/domain/repositories/auth_repository.dart';
import 'package:app_auth/features/user/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<UserEntity> signInWithEmailAndPassword(
      String email, String password) async {
    final userModel =
        await dataSource.signInWithEmailAndPassword(email, password);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword(
      String email, String password, String name) async {
    final userModel =
        await dataSource.registerWithEmailAndPassword(email, password, name);
    return userModel.toEntity();
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }
}

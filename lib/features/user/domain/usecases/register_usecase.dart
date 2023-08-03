import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import 'package:equatable/equatable.dart';

class RegisterWithEmailAndPasswordUseCase {
  final AuthRepository repository;

  RegisterWithEmailAndPasswordUseCase({required this.repository});

  Future<UserEntity> call(String email, String password, String name) {
    return repository.registerWithEmailAndPassword(email, password, name);
  }
}

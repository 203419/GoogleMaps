import '../repositories/auth_repository.dart';
import '../entities/user.dart';
import 'package:equatable/equatable.dart';

class SignInWithEmailAndPasswordUseCase {
  final AuthRepository repository;

  SignInWithEmailAndPasswordUseCase({required this.repository});

  Future<UserEntity> call(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}

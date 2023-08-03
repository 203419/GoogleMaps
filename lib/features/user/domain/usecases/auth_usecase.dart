import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailAndPasswordUseCase {
  final AuthRepository repository;

  SignInWithEmailAndPasswordUseCase({required this.repository});

  Future<UserEntity> call(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}

class RegisterWithEmailAndPasswordUseCase {
  final AuthRepository repository;

  RegisterWithEmailAndPasswordUseCase({required this.repository});

  Future<UserEntity> call(String email, String password, String name) {
    return repository.registerWithEmailAndPassword(email, password, name);
  }
}

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}

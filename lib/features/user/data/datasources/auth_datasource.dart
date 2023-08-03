import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password, String name);
  Future<void> signOut();
}

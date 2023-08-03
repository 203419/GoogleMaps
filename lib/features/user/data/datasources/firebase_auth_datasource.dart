import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthDataSource({required this.firebaseAuth});

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password, String name) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(name);
    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<void> signOut() {
    return firebaseAuth.signOut();
  }
}

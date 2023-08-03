import 'package:app_auth/features/archives/presentation/pages/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_auth/features/user/presentation/pages/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_auth/features/user/presentation/pages/register.dart';
import 'package:app_auth/features/user/data/repositories/auth_repository_impl.dart';
import 'package:app_auth/features/user/data/datasources/auth_datasource.dart';
import 'package:app_auth/features/user/data/datasources/firebase_auth_datasource.dart';
import 'package:app_auth/features/user/domain/usecases/auth_usecase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/archives/domain/usecases/message_usecases.dart';
import 'package:app_auth/features/archives/domain/repositories/message_repository.dart';
import 'package:app_auth/features/archives/data/repositories/message_repository_impl.dart';
import 'package:app_auth/features/archives/data/datasources/message_datasource.dart';
import 'package:app_auth/features/archives/domain/entities/message.dart';
import 'package:app_auth/features/archives/presentation/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<GetMessagesUseCase>(
          create: (context) => GetMessagesUseCase(
            MessageRepositoryImpl(
              FirebaseMessageDataSource(
                firestore: FirebaseFirestore.instance,
                storage: FirebaseStorage.instance,
              ),
            ),
          ),
        ),
        Provider<SaveMessageUseCase>(
          create: (context) => SaveMessageUseCase(
            MessageRepositoryImpl(
              FirebaseMessageDataSource(
                firestore: FirebaseFirestore.instance,
                storage: FirebaseStorage.instance,
              ),
            ),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  MyApp();

  @override
  Widget build(BuildContext context) {
    final AuthDataSource authDataSource =
        FirebaseAuthDataSource(firebaseAuth: firebaseAuth);
    final AuthRepositoryImpl authRepository =
        AuthRepositoryImpl(dataSource: authDataSource);
    final SignInWithEmailAndPasswordUseCase signInUseCase =
        SignInWithEmailAndPasswordUseCase(repository: authRepository);
    final RegisterWithEmailAndPasswordUseCase registerUseCase =
        RegisterWithEmailAndPasswordUseCase(repository: authRepository);

    return MaterialApp(
      title: 'Red social',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(
        signInUseCase: signInUseCase,
      ),
      routes: {
        '/register': (_) => RegisterPage(
              registerUseCase: registerUseCase,
            ),
        '/home': (_) => Home(),
      },
    );
  }
}

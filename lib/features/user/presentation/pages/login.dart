import 'package:flutter/material.dart';
import 'package:app_auth/features/user/domain/entities/user.dart';
import 'package:app_auth/features/user/domain/usecases/auth_usecase.dart';
import '../pages/register.dart';

class LoginPage extends StatefulWidget {
  final SignInWithEmailAndPasswordUseCase signInUseCase;

  LoginPage({required this.signInUseCase});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserEntity user = await widget.signInUseCase(email, password);
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to "/home"
    } catch (e) {
      // Handle login failure
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _goToRegister() {
    Navigator.pushNamed(context, '/register'); // Navigate to "/register"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF23395B),
        centerTitle: true,
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 46.0),
              const Text(
                'Inicia sesión ',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 56.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 46.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
                // darle estilo redoondo al boton y hacerlo mas grande
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF23395B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 20.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: _goToRegister,
                child: Text(
                  'Register',
                  style: TextStyle(color: Color(0xFF23395B)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:app_auth/features/user/domain/entities/user.dart';
import 'package:app_auth/features/user/domain/usecases/auth_usecase.dart';

class RegisterPage extends StatefulWidget {
  final RegisterWithEmailAndPasswordUseCase registerUseCase;

  RegisterPage({required this.registerUseCase});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    try {
      UserEntity user = await widget.registerUseCase(email, password, name);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Handle registration failure
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registration Failed'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF23395B),
        centerTitle: true,
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 36.0),
              const Text(
                'Registra tu cuenta',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 36.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
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
                onPressed: _register,
                child: Text('Register'),
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
            ],
          ),
        ),
      ),
    );
  }
}

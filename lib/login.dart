import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psf1/registro.dart';
import 'bienvenido.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;  // Nueva variable para controlar el estado de carga

  Future<void> _login() async {
    setState(() {
      _isLoading = true;  // Comienza el proceso de autenticación
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        print('Login exitoso: ${userCredential.user?.uid}');
        
        // Redirigir a la pantalla de bienvenida si la autenticación es exitosa
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BienvenidoPage(user: userCredential.user),
          ),
        );
      } else {
        print('No se pudo autenticar al usuario.');
        if (mounted) {
          setState(() {
            _errorMessage = 'No se pudo autenticar al usuario.';
          });
        }
      }
    } catch (e) {
      print('Error durante el login: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;  // Termina el proceso de autenticación
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Ingrese su email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Ingrese su contraseña',
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)  // Mostrar el indicador de carga si _isLoading es true
              CircularProgressIndicator(),
            if (!_isLoading)
              ElevatedButton(
                onPressed: _login,  // Ejecutar el proceso de login
                child: Text('Iniciar sesión'),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Redirigir a la pantalla de registro
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegistroPage(),
                  ),
                );
              },
              child: Text('Registrarse'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

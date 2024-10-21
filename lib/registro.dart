import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bienvenido.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      if (userCredential.user != null) {
        print("Registro exitoso: ${userCredential.user?.email}");
        // Redirigir a la pantalla de bienvenida si el registro es exitoso
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BienvenidoPage(user: userCredential.user),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Error durante el registro: $e');
      if (e.code == 'weak-password') {
        setState(() {
          _errorMessage = 'La contraseña es muy débil.';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _errorMessage = 'El correo ya está registrado.';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          _errorMessage = 'El correo no es válido.';
        });
      } else {
        setState(() {
          _errorMessage = 'Error inesperado: ${e.message}';
        });
      }
    } catch (e) {
      print('Error inesperado durante el registro: $e');
      setState(() {
        _errorMessage = 'Error inesperado: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
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
            ElevatedButton(
              onPressed: _register,
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BienvenidoPage extends StatelessWidget {
  final User? user;

  BienvenidoPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
      ),
      body: Center(
        child: Text('Hola, ${user?.email}, ¡Bienvenido a la aplicación!'),
      ),
    );
  }
}

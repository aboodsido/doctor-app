import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(220, 0, 71, 250),
      ),
      body: const Center(
        child: Text(
          'Register Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

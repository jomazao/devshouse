import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devshouse/screens/my_courses/my_courses_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:devshouse/extension/desing_extensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  bool _loading = false;
  bool _registering = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(label: Text('Correo Electrónico')),
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration:
                    const InputDecoration(label: Text('Crea una contraseña')),
              ),
              if (_registering)
                TextFormField(
                  obscureText: true,
                  controller: _passwordConfirmationController,
                  decoration: const InputDecoration(
                      label: Text('Repite la contraseña')),
                ),
              10.0.spaceV,
              if (_loading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                    onPressed: _registering ? _register : _login,
                    child: Text(_registering ? 'Registrarse' : 'Ingresar')),
              if (_registering)
                ElevatedButton(
                    onPressed: _cancelRegister, child: const Text('Cancelar')),
            ],
          ),
        ),
      ),
    );
  }

  void _cancelRegister() {
    setState(() {
      _registering = false;
    });
  }

  void _register() async {
    final email = _emailController.text;
    final passWord = _passwordController.text;
    final passWordRepeat = _passwordConfirmationController.text;
    if (passWord != passWordRepeat) {
      const snackBar = SnackBar(
        content: Text('Las contraseñas no coinciden'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() {
      _loading = true;
    });

    FocusManager.instance.primaryFocus?.unfocus();
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: passWord);
      setState(() {
        _loading = false;
      });
      final user = userCredential.user;
      if (userCredential.user != null) {
        CollectionReference users = FirebaseFirestore.instance.collection('users');
        await users
            .doc(user?.uid).set({'email': user?.email})
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
        Navigator.of(context).push( MaterialPageRoute(builder: (context) => const MyCoursesScreen()),);
      } else {
        const snackMessage = 'Por algún motivo no ingresó';
        const  snackBar = SnackBar(
          content: Text(snackMessage),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on FirebaseAuthException catch (e) {
      late String snackBarMessage;

      if (e.code == 'weak-password') {
        snackBarMessage = 'Esa contraseña es muy fácil';
      } else if (e.code == 'email-already-in-use') {
        snackBarMessage = 'Ya están usando ese correo, no eres tú?';
      }
      final snackBar = SnackBar(
        content: Text(snackBarMessage),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print(e);
    }
    setState(() {
      _registering = false;
    });
  }

  void _login() async {
    final email = _emailController.text;
    final passWord = _passwordController.text;
    setState(() {
      _loading = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: passWord);
      if (userCredential.user != null) {
        Navigator.of(context).push( MaterialPageRoute(builder: (context) => const MyCoursesScreen()),);
      } else {
        const snackMessage = 'Por algún motivo no ingresó';
        const snackBar = SnackBar(
          content: Text(snackMessage),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on FirebaseAuthException catch (e) {
      late String snackBarMessage;

      switch (e.code) {
        case 'user-not-found':
          snackBarMessage = 'Aún no estás registrad@, crea una contraseña';
          setState(() {
            _registering = true;
            _passwordController.text = '';
            _passwordConfirmationController.text = '';
          });
          break;
        case 'wrong-password':
          snackBarMessage = 'Metiste mal el deo, corrije la contraseña';
          break;
        case 'invalid-email':
          snackBarMessage = 'Eso nisiquiera es un correo electrónico';
          break;
        default:
          print(e.code);
          snackBarMessage = 'Algo raro está pasando :(';
      }

      final snackBar = SnackBar(
        content: Text(snackBarMessage),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _loading = false;
    });
  }
}

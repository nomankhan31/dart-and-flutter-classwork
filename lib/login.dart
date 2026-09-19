import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

final CollectionReference login = FirebaseFirestore.instance.collection('student');

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
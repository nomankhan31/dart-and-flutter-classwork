import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

TextEditingController name =TextEditingController();
TextEditingController age =TextEditingController();
TextEditingController email =TextEditingController();
TextEditingController password =TextEditingController();

final CollectionReference reg = FirebaseFirestore.instance.collection('Customer');


Future <void> adduser(BuildContext)async{

await reg.add({

'name' : name.text.trim(),
'age' : age.text.trim(),
'email' : email.text.trim(),
'password' : password.text.trim(),
'role' : 'user',
});
Navigator.pushNamed(context,'/login');
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
  body: Column(
    children: [
      TextField(
    controller: name,
    decoration: InputDecoration(
      labelText: 'Name'
    ),
  ),
  TextField(
    controller: age,
    decoration: InputDecoration(
      labelText: 'Age'
    ),
  ),
  TextField(
    controller: email,
    decoration: InputDecoration(
      labelText: 'Email'
    ),
  ),
  TextField(
    controller: password,
    decoration: InputDecoration(
      labelText: 'Password'
    ),
  ),
    ],
  ),

        
    );
  }
}
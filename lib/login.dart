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

  final CollectionReference login =
      FirebaseFirestore.instance.collection('student');

  bool loading = false;
  bool hidePassword = true;

  // ================= LOGIN FUNCTION =================

  Future<void> userLogin() async {
    String userEmail = email.text.trim();
    String userPassword = password.text.trim();

    if (userEmail.isEmpty || userPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email and password"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      QuerySnapshot result = await login
          .where('email', isEqualTo: userEmail)
          .where('password', isEqualTo: userPassword)
          .get();

      if (result.docs.isNotEmpty) {
        // Login successful

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Successful"),
            ),
          );

          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
          );
        }
      } else {
        // Wrong email/password

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Wrong Email or Password"),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),

          child: Card(
            elevation: 5,

            child: Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  // ================= TITLE =================

                  const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Student Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= EMAIL =================

                  TextField(
                    controller: email,

                    keyboardType:
                        TextInputType.emailAddress,

                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ================= PASSWORD =================

                  TextField(
                    controller: password,

                    obscureText: hidePassword,

                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",

                      prefixIcon:
                          const Icon(Icons.lock),

                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword =
                                !hidePassword;
                          });
                        },

                        icon: Icon(
                          hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),

                      border:
                          const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= LOGIN BUTTON =================

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed:
                          loading ? null : userLogin,

                      child: loading
                          ? const SizedBox(
                              height: 25,
                              width: 25,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}

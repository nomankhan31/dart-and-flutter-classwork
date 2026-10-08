import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // ================= CONTROLLERS =================

  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword =
      TextEditingController();

  // ================= FIRESTORE =================

  final CollectionReference reg =
      FirebaseFirestore.instance.collection('customer');

  bool loading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  // ================= REGISTER =================

  Future<void> addUser() async {
    final String userName = name.text.trim();
    final String userAge = age.text.trim();
    final String userEmail = email.text.trim();
    final String userPassword = password.text.trim();
    final String confirmPass =
        confirmPassword.text.trim();

    final int? ageValue = int.tryParse(userAge);

    // ================= VALIDATION =================

    if (userName.isEmpty ||
        userAge.isEmpty ||
        userEmail.isEmpty ||
        userPassword.isEmpty ||
        confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    if (ageValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid age"),
        ),
      );
      return;
    }

    if (userEmail.contains('@') == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid email"),
        ),
      );
      return;
    }

    if (userPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password must be at least 6 characters",
          ),
        ),
      );
      return;
    }

    if (userPassword != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      // ================= CHECK EMAIL =================

      final QuerySnapshot existingUser = await reg
          .where(
            'email',
            isEqualTo: userEmail,
          )
          .get();

      if (existingUser.docs.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "This email is already registered",
              ),
            ),
          );
        }

        setState(() {
          loading = false;
        });

        return;
      }

      // ================= ADD USER =================

      await reg.add({
        'name': userName,
        'age': ageValue,
        'email': userEmail,
        'password': userPassword,
        'role': 'user',
        'status': 'pending',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Registration successful",
          ),
        ),
      );

      // Clear fields
      name.clear();
      age.clear();
      email.clear();
      password.clear();
      confirmPassword.clear();

      // Go to Login
      Navigator.pushReplacementNamed(
        context,
        '/login',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registration failed: $e",
            ),
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

      appBar: AppBar(
        title: const Text("Create Account"),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Card(
            elevation: 5,

            child: Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                children: [
                  // ================= ICON =================

                  const Icon(
                    Icons.person_add,
                    size: 70,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= NAME =================

                  TextField(
                    controller: name,
                    textCapitalization:
                        TextCapitalization.words,

                    decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Enter your name",
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ================= AGE =================

                  TextField(
                    controller: age,
                    keyboardType:
                        TextInputType.number,

                    decoration: const InputDecoration(
                      labelText: "Age",
                      hintText: "Enter your age",
                      prefixIcon: Icon(
                        Icons.calendar_today,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ================= EMAIL =================

                  TextField(
                    controller: email,
                    keyboardType:
                        TextInputType.emailAddress,

                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixIcon: Icon(
                        Icons.email,
                      ),
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
                      hintText: "Enter password",
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),

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

                  const SizedBox(height: 15),

                  // ================= CONFIRM PASSWORD =================

                  TextField(
                    controller: confirmPassword,
                    obscureText:
                        hideConfirmPassword,

                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText:
                          "Enter password again",

                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),

                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hideConfirmPassword =
                                !hideConfirmPassword;
                          });
                        },

                        icon: Icon(
                          hideConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),

                      border:
                          const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= REGISTER BUTTON =================

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed:
                          loading ? null : addUser,

                      child: loading
                          ? const SizedBox(
                              height: 25,
                              width: 25,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "REGISTER",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ================= LOGIN =================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      const Text(
                        "Already have an account?",
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/login',
                          );
                        },

                        child: const Text(
                          "Login",
                        ),
                      ),
                    ],
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
    name.dispose();
    age.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();

    super.dispose();
  }
}

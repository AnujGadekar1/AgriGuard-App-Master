import 'dart:developer';
import 'package:agro_chemical_management/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agro_chemical_management/login/forget.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      log("please fill also ");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  HomeScreen()));
      } on FirebaseAuthException catch (ex) {
        // Show a Snackbar with the exception message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ex.message ?? 'An error occurred'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        // Wrap your Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome Back !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 54,
                width: 329,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: buildInputField(
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  controller: emailController,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 54,
                width: 329,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: buildInputField(
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  controller: passwordController,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen()));
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 127, 68),
                    ), // Adjust text color as needed
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Call the login method when the button is pressed
                  login();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Login',
                
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          border: InputBorder.none,
        ),
        obscureText: obscureText,
      ),
    );
  }
}

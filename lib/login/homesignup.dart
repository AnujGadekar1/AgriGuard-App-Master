import 'package:flutter/gestures.dart'; // Import gesture recognizer
import 'package:flutter/material.dart';
import 'package:agro_chemical_management/login/login.dart';
import 'package:agro_chemical_management/login/signup.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Set background color to white
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/agri-logo.png',
                  width: 500,
                  height: 500,
                ),
              ),
              const SizedBox(height: 5), // Add spacing
              SizedBox(
                width: 311,
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your sign-up logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button background color
                    textStyle: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 20,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '  Sign Up   ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15), // Add spacing
              RichText(
                text: TextSpan(
                  text: 'Already registered? ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors
                        .black, // Set color for the "Already registered?" text
                  ),
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Color.fromARGB(
                            255, 255, 127, 68), // Custom color for Login text
                        decoration: TextDecoration.none,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Adding Login page here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

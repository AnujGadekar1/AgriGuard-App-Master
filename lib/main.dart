import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:agro_chemical_management/firebase_options.dart'; // Ensure you have this file for Firebase configuration
import 'package:agro_chemical_management/login/signup.dart';
import 'screens/home_screen.dart';
import 'package:agro_chemical_management/login/homesignup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AgroChemicalManagementApp());
}

class AgroChemicalManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroChemical Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => (FirebaseAuth.instance.currentUser != null)
            ?  HomeScreen() // directed to homescreen if already login 
            : const MyHomePage(), // directed to login screen if not logined 
      },
    );
  }
}

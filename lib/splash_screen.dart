import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Auth/login_page.dart';
import 'Doctor/doctor_home_page.dart';
import 'Patient/patient_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAuthUser();
  }

  Future<void> _checkAuthUser() async {
    User? user = _auth.currentUser;

    if (user == null) {
      await Future.delayed(const Duration(seconds: 3));
      _navigateToLogin();
    } else {
      DatabaseReference userRef = _database.child("Doctor").child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        await Future.delayed(const Duration(seconds: 3));
        _navigateToDoctorHomePage();
      } else {
        userRef = _database.child("Patient").child(user.uid);
        snapshot = await userRef.get();
        if (snapshot.exists) {
          await Future.delayed(const Duration(seconds: 3));
          _navigateToPatientHomePage();
        } else {
          await Future.delayed(const Duration(seconds: 3));
          _navigateToLogin();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(220, 0, 71, 250),
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                "Welcome!",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text("Transforming Healthcare",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 30),
              const Icon(
                Icons.healing,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _navigateToDoctorHomePage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const DoctorHomePage()));
  }

  void _navigateToPatientHomePage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const PatientHomePage()));
  }
}

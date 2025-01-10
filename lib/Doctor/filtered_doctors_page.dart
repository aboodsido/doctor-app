import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/doctor_model.dart';
import 'doctor_details_page.dart';
import 'widgets/doctor_card.dart';

class FilteredDoctorsPage extends StatefulWidget {
  final String category;

  const FilteredDoctorsPage({super.key, required this.category});

  @override
  State<FilteredDoctorsPage> createState() => _FilteredDoctorsPageState();
}

class _FilteredDoctorsPageState extends State<FilteredDoctorsPage> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Doctors');
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFilteredDoctors();
  }

  Future<void> _fetchFilteredDoctors() async {
    await _database.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      List<Doctor> tmpDoctors = [];
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          Doctor doctor = Doctor.fromMap(value, key);

          if (doctor.category.toLowerCase().trim() ==
              widget.category.toLowerCase().trim()) {
            tmpDoctors.add(doctor);
          }
        });
      }
      setState(() {
        _filteredDoctors = tmpDoctors;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        '${widget.category} Doctors',
        style: GoogleFonts.poppins(),
      )),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _filteredDoctors.isEmpty
              ? const Center(
                  child: Text(
                    'No doctors found in this category.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorDetailPage(
                                  doctor: _filteredDoctors[index]),
                            ),
                          );
                        },
                        child: DoctorCard(doctor: _filteredDoctors[index]),
                      );
                    },
                  ),
                ),
    );
  }
}

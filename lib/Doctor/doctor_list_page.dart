import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/doctor_model.dart';
import 'all_doctors_page.dart';
import 'doctor_details_page.dart';
import 'filtered_doctors_page.dart';
import 'widgets/doctor_card.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Doctors');
  List<Doctor> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    await _database.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      List<Doctor> tmpDoctors = [];
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          Doctor doctor = Doctor.fromMap(value, key);
          tmpDoctors.add(doctor);
        });
      }
      setState(() {
        _doctors = tmpDoctors;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Find your doctor,\nand book an appointment',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Find Doctor by Category',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryCard(
                          context, 'Cardiology', 'assets/images/heart.png'),
                      _buildCategoryCard(
                          context, 'Dentist', 'assets/images/dental.png'),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryCard(
                          context, 'Oncology', 'assets/images/onco.png'),
                      _buildCategoryCard(
                          context, 'See All', 'assets/images/grid.png',
                          isHighlighed: true),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Doctors',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AllDoctorsPage()));
                        },
                        child: Text(
                          'VIEW ALL',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff006AFA),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _doctors.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DoctorDetailPage(doctor: _doctors[index]),
                                ),
                              );
                            },
                            child: DoctorCard(doctor: _doctors[index]));
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget _buildCategoryCard(BuildContext context, String title, dynamic icon,
    {bool isHighlighed = false}) {
  return GestureDetector(
    onTap: () {
      if (title != 'See All') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilteredDoctorsPage(category: title),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AllDoctorsPage(),
          ),
        );
      }
    },
    child: Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          color:
              isHighlighed ? const Color(0xff006AFA) : const Color(0xffF0EFFF),
          borderRadius: BorderRadius.circular(15),
          border: isHighlighed
              ? null
              : Border.all(color: const Color(0xffC8C4FF), width: 2)),
      child: Card(
        color: isHighlighed ? const Color(0xff006AFA) : const Color(0xffF0EFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon is IconData)
                Icon(
                  icon,
                  size: 40,
                  color: isHighlighed ? Colors.white : const Color(0xffF0EFFF),
                )
              else
                Image.asset(
                  icon,
                  width: 40,
                  height: 40,
                ),
              const SizedBox(
                height: 16,
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: isHighlighed ? Colors.white : const Color(0xff006AFA),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

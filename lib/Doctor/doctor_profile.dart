import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Auth/login_page.dart';
import '../model/doctor_model.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Doctors');
  Doctor? _doctor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final String uid = currentUser.uid;
        DataSnapshot snapshot = await _database.child(uid).get();
        if (snapshot.exists) {
          setState(() {
            _doctor =
                Doctor.fromMap(snapshot.value as Map<dynamic, dynamic>, uid);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching doctor details: $e');
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }

  void _showEditDialog(
      String fieldName, String initialValue, Function(String) onSave) {
    final TextEditingController _controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $fieldName'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: fieldName,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedValue = _controller.text.trim();
              if (updatedValue.isNotEmpty) {
                onSave(updatedValue);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _updateDoctorField(String field, String value) async {
    if (_doctor != null) {
      try {
        await _database.child(_doctor!.uid).update({field: value});
        setState(() {
          switch (field) {
            case 'firstName':
              _doctor = _doctor!.copyWith(firstName: value);
              break;
            case 'lastName':
              _doctor = _doctor!.copyWith(lastName: value);
              break;
            case 'city':
              _doctor = _doctor!.copyWith(city: value);
              break;
            case 'phoneNumber':
              _doctor = _doctor!.copyWith(phoneNumber: value);
              break;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$field updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update $field.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _doctor == null
              ? const Center(
                  child: Text(
                    'No profile information found.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _doctor!.profileImageUrl.isNotEmpty
                            ? NetworkImage(_doctor!.profileImageUrl)
                            : null,
                        child: _doctor!.profileImageUrl.isEmpty
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${_doctor!.firstName} ${_doctor!.lastName}',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog(
                                'Name',
                                '${_doctor!.firstName} ${_doctor!.lastName}',
                                (updatedName) {
                                  final parts = updatedName.split(' ');
                                  if (parts.length >= 2) {
                                    _updateDoctorField(
                                        'firstName', parts.first);
                                    _updateDoctorField('lastName', parts.last);
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'City: ${_doctor!.city}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog('City', _doctor!.city,
                                  (updatedCity) {
                                _updateDoctorField('city', updatedCity);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Phone: ${_doctor!.phoneNumber}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog(
                                  'Phone Number', _doctor!.phoneNumber,
                                  (updatedPhone) {
                                _updateDoctorField('phoneNumber', updatedPhone);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}

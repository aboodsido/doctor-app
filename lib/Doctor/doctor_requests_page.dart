import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/booking_model.dart';

class DoctorRequestsPage extends StatefulWidget {
  const DoctorRequestsPage({super.key});

  @override
  State<DoctorRequestsPage> createState() => _DoctorRequestsPageState();
}

class _DoctorRequestsPageState extends State<DoctorRequestsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _requestDatabase =
      FirebaseDatabase.instance.ref().child('Requests');
  final List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    String? currentUserId = _auth.currentUser?.uid;
    if (currentUserId != null) {
      await _requestDatabase
          .orderByChild('receiver')
          .equalTo(currentUserId)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> bookingMap =
              event.snapshot.value as Map<dynamic, dynamic>;
          _bookings.clear();
          bookingMap.forEach((key, value) {
            _bookings.add(Booking.fromMap(Map<String, dynamic>.from(value)));
          });
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Requests'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? const Center(child: Text('No booking available'))
              : ListView.builder(
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        child: ListTile(
                          title: Text(booking.description),
                          subtitle: Text(
                              'Date: ${booking.date} Time: ${booking.time}'),
                          trailing: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: booking.status == 'Accepted'
                                  ? Colors.green
                                  : booking.status == 'Rejected'
                                      ? Colors.red
                                      : booking.status == 'Completed'
                                          ? Colors.blue
                                          : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              booking.status,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () =>
                              _showStatusDialog(booking.id, booking.status),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showStatusDialog(String requestId, String currentStatus) {
    List<String> statuses = ['Accepted', 'Rejected', 'Completed'];
    String selectedStatus = currentStatus;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Request Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please select the status for this request.'),
                  const SizedBox(height: 16.0),
                  Column(
                    children: List.generate(statuses.length, (index) {
                      return RadioListTile<String>(
                        title: Text(statuses[index]),
                        value: statuses[index],
                        groupValue: selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await _updateRequestStatus(requestId, selectedStatus);
                    Navigator.pop(context);
                  },
                  child: const Text('Update Status'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateRequestStatus(String requestId, String status) async {
    await _requestDatabase.child(requestId).update({
      'status': status,
    });
    await _fetchBookings();
  }
}

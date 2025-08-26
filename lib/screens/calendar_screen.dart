
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _TaskCalendarSfScreenState();
}

class _TaskCalendarSfScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getTasksForDate() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final start =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final end = start.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("tasks")
        .where("date", isGreaterThanOrEqualTo: start)
        .where("date", isLessThan: end)
        .orderBy("date", descending: true)
        .snapshots();
  }

  void _onSelectionChanged(CalendarSelectionDetails details) {
    setState(() {
      _selectedDate = details.date ?? DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Calendar",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
          stream: getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Terjadi error"));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("User data not found"));
            }

            final userData = snapshot.data!.data()!;
            final usernameDisplay = userData['username'] ?? 'User';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Productive Day, ${usernameDisplay}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat.yMMMMd().format(_selectedDate),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 250,
                  child: SfCalendar(
                    view: CalendarView.month,
                    showNavigationArrow: true,
                    onSelectionChanged: _onSelectionChanged,
                    todayHighlightColor: Colors.teal,
                    selectionDecoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.3),
                      border: Border.all(color: Colors.teal, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: StreamBuilder(
                    stream: _getTasksForDate(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text("No tasks for this day"));
                      }

                      final tasks = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index].data();
                          final time = task["time"] ?? "";
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  time,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(task["title"] ?? ""),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:projek2_aplikasi_todolist/widgets/category.dart';
import 'package:projek2_aplikasi_todolist/widgets/snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskDoneScreen extends StatefulWidget {
  const TaskDoneScreen({super.key});

  @override
  State<TaskDoneScreen> createState() => _TaskDoneScreenState();
}

class _TaskDoneScreenState extends State<TaskDoneScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>> getTaskDone() {
    final user = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('tasks')
        .where('status', isEqualTo: true)
        .snapshots();
  }

  void showDeleteDialog(String taskId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: "Confirm Delete Data",
      desc: "Are You Sure You Want To Delete Data?",
      showCloseIcon: true,
      btnOkOnPress: () async {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('tasks')
              .doc(taskId)
              .delete();
          successShowTopSnackBar(context, "Task deleted successfully.");
        } catch (_) {
          failedShowTopSnackBar(context, "Failed deleted task.");
        }
      },
      btnCancelOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFA0D7C8), Color(0xFFA0C7D7)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Done To Do',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // List tugas selesai
            Expanded(
              child: StreamBuilder(
                stream: getTaskDone(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading tasks"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No tasks completed yet."));
                  }

                  final tasks = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.all(30),
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index].data();
                        final taskId = tasks[index].id;
                        final categoryKey = (task['category'] ?? '').toString();

                        // Date formatting
                        final Timestamp dateTimeStamp =
                            task['date'] ?? Timestamp.now();
                        final DateTime dateTime = dateTimeStamp.toDate();
                        final String formattedDate =
                            DateFormat('d MMM yyyy').format(dateTime);
                        final time = task['time'] ?? '';

                        // Priority
                        final priority = task['priority'] ?? 3; // default Low
                        String priorityText;
                        switch (priority) {
                          case 1:
                            priorityText = "High";
                            break;
                          case 2:
                            priorityText = "Mid";
                            break;
                          default:
                            priorityText = "Low";
                        }

                        final subtitleText =
                            "$formattedDate • $time • $priorityText";

                        return Column(
                          children: [
                            Slidable(
                              key: ValueKey(taskId),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) => showDeleteDialog(taskId),
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: Card(
                                color: const Color(0xFFA0D7C8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      categoryIcon[categoryKey] ?? Icons.apps,
                                      size: 30,
                                    ),
                                  ),
                                  title: Text(
                                    task['title'] ?? 'Untitled',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF584A4A),
                                    ),
                                  ),
                                  subtitle: Text(
                                    subtitleText,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF584A4A),
                                    ),
                                  ),
                                  trailing: IgnorePointer(
                                    child: Checkbox(
                                      value: task['status'],
                                      onChanged: (_) {} // disable checkbox
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

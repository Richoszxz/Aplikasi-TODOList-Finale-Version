import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:projek2_aplikasi_todolist/screens/task_done_screen.dart';
import 'package:projek2_aplikasi_todolist/widgets/snack_bar.dart';
import 'package:projek2_aplikasi_todolist/widgets/category.dart';

class TaskTodoScreen extends StatefulWidget {
  const TaskTodoScreen({super.key});

  @override
  State<TaskTodoScreen> createState() => _TaskTodoScreenState();
}

class _TaskTodoScreenState extends State<TaskTodoScreen> {
  bool fungsiCheckBox = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  void showDeleteDialog(String docId) {
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
              .doc(userId)
              .collection('tasks')
              .doc(docId)
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
                color: Color(0xFFA0D7C8),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'To Do Day',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF584A4A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMMM d, yyyy').format(DateTime.now()),
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF584A4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // Task List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('tasks')
                    .where('status', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Task not yet."),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return Padding(
                    padding: EdgeInsets.all(30),
                    child: ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final task = docs[index].data() as Map<String, dynamic>;
                        final docId = docs[index].id;
                        final Timestamp dateTimeStamp = task['date'] ?? '';
                        final DateTime dateTime = dateTimeStamp.toDate();
                        final String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
                        final time = task['time'] ?? '';
                        final priority = task['priority'] ?? 3; // default low
                        final categoryKey = (task['category'] ?? '').toString();

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
                            break;
                        }

                        // Subtitle format: "14 Aug 2025 • 07:00 • High"
                        final subtitleText = "$formattedDate • $time • $priorityText";

                        return Column(
                          children: [
                            Slidable(
                              key: ValueKey(docId),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) => showDeleteDialog(docId),
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
                                        size: 30),
                                  ),
                                  title: Text(
                                    task['title'] ?? '',
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
                                  trailing: Checkbox(
                                    value: task['status'] ?? false,
                                    onChanged: (bool? value) async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userId)
                                          .collection('tasks')
                                          .doc(docId)
                                          .update({'status': value ?? false});
                                      if (value == true) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TaskDoneScreen(),
                                          ),
                                        );
                                      }
                                    },
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

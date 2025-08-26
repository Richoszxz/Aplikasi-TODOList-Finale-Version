import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendar_screen.dart';
import 'task_todo_screen.dart';
import 'task_done_screen.dart';
import 'my_profile_screen.dart';
import 'create_task_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser() {
    final user = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(user).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
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
            final bioDisplay = userData['bio'] ?? 'No bio yet.';

            return SingleChildScrollView(
              // scroll biar aman
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.account_circle_outlined,
                              size: 60),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          // supaya teks ga overflow
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello,',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  color: const Color(0xFF584A4A),
                                ),
                              ),
                              Text(
                                usernameDisplay,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  color: const Color(0xFF584A4A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                bioDisplay,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF584A4A),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Task',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF584A4A),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // To Do Card
                        _buildTaskCard(
                          context,
                          icon: Icons.schedule,
                          title: "To Do",
                          subtitle: "5 Task Now",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TaskTodoScreen()),
                          ),
                          screenWidth: screenWidth,
                        ),

                        const SizedBox(height: 16),

                        // Done Card
                        _buildTaskCard(
                          context,
                          icon: Icons.check_circle_outline,
                          title: "Done",
                          subtitle: "5 Task Now | 3 Task Done",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TaskDoneScreen()),
                          ),
                          screenWidth: screenWidth,
                        ),

                        const SizedBox(height: 16),

                        // Calendar Card
                        _buildTaskCard(
                          context,
                          icon: Icons.calendar_month,
                          title: "Calendar Appointment",
                          subtitle: "",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CalendarScreen()),
                          ),
                          screenWidth: screenWidth,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Thank you card
                  Center(
                    child: Container(
                      width: screenWidth * 0.9, // responsive
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFA0D7C8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "Terima Kasih sudah menjadi manusia \nbertanggung jawab\n"
                        "Klik tombol '+' di bawah untuk tambah tugas",
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // biar ga ketutup FAB
                ],
              ),
            );
          },
        ),
      ),

      // FAB + BottomNav
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: const Color(0xFFA0D7C8),
          elevation: 2,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
            );
          },
          child: const Icon(Icons.add, size: 36, color: Colors.black),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFFA0D7C8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              ),
              icon: const Icon(Icons.home, color: Color(0xFF584A4A), size: 40),
            ),
            // const Spacer(),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyProfileScreen()),
              ),
              icon:
                  const Icon(Icons.person, color: Color(0xFF584A4A), size: 40),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable card widget
  Widget _buildTaskCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
      required double screenWidth}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.9,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFA0D7C8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(icon, size: 40),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF584A4A),
                      )),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF584A4A),
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

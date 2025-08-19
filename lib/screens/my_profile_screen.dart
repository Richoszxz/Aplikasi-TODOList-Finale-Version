import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projek2_aplikasi_todolist/screens/splash_screen.dart';
import 'package:projek2_aplikasi_todolist/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreen();
}

class _MyProfileScreen extends State<MyProfileScreen> {
  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final noTelController = TextEditingController();
  DateTime? birthDate;

  DateTime? tanggalTerpilih;
  TimeOfDay? waktuTerpilih;

  String get formatTanggal {
    if (tanggalTerpilih == null) return '';
    return DateFormat('MMMM d,yyyy').format(tanggalTerpilih!);
  }

  String get formatWaktu {
    if (waktuTerpilih == null) return '';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, waktuTerpilih!.hour,
        waktuTerpilih!.minute);
    return DateFormat('HH:mm').format(dt);
  }

  // GET USER DATA
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  // EDIT USER DATA
  Future<void> editUser() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'username': usernameController.text.trim(),
        'bio': bioController.text.trim(),
        'noTelepon': noTelController.text.trim(),
        'tanggalLahir': tanggalTerpilih,
        'updatedAt': FieldValue.serverTimestamp()
      });
      successShowTopSnackBar(context, "Edit user data successfully!");
    } catch (_) {
      failedShowTopSnackBar(context, "Failed edit user data.");
    }
  }

  Future<void> _logOut(BuildContext context) async {
    bool? konfirmasiLogOut = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Log Out",
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.w700)),
        content: Text("Are you sure you want to log out?",
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              "Log Out",
              style: GoogleFonts.poppins(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );

    if (konfirmasiLogOut == true) {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
        );
        successShowTopSnackBar(context, "Logged out successfully.");
      } catch (_) {
        failedShowTopSnackBar(context, "Failed to log out.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            final birthDateDisplay =
                (userData['tanggalLahir'] as Timestamp?)?.toDate();
            final noTelDisplay =
                userData['noTelepon'] ?? 'Number phone note set.';

            final formattedBirthDate = birthDateDisplay != null
                ? DateFormat('d MMMM yyyy').format(birthDateDisplay)
                : "Not set";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian atas (judul + tanggal)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  decoration: const BoxDecoration(
                    color: Color(0xFFA0D7C8),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Profil',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF584A4A),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.account_circle_outlined,
                                // color: Colors.black,
                                size: 70,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              usernameDisplay,
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF584A4A),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 10,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        width: 250,
                                        height: 450,
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFA0D7C8),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 10,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Card(
                                          color: Color(0xFFA0D7C8),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Edit Profile",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                child: TextFormField(
                                                  controller:
                                                      usernameController,
                                                  decoration: InputDecoration(
                                                    labelStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    hintText:
                                                        "azura aulia selly",
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                    labelText: "Name",
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 3.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  controller: bioController,
                                                  decoration: InputDecoration(
                                                    labelStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    hintText: "My Journey",
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                    labelText: "Bio",
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 3.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                child: GestureDetector(
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    controller:
                                                        TextEditingController(
                                                            text:
                                                                formatTanggal),
                                                    onTap: () async {
                                                      final DateTime? terpilih =
                                                          await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            tanggalTerpilih ??
                                                                DateTime.now(),
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2100),
                                                      );
                                                      if (terpilih != null) {
                                                        setState(() {
                                                          tanggalTerpilih =
                                                              terpilih;
                                                        });
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      labelStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      hintText:
                                                          "Select birth date",
                                                      hintStyle:
                                                          GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                      labelText: "Birth Date",
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        borderSide: BorderSide(
                                                            color: Colors.white,
                                                            width: 3.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  controller: noTelController,
                                                  decoration: InputDecoration(
                                                    labelStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    hintText: "081252466822",
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                    labelText: "Number Phone",
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 3.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 3.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    editUser();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFF4CAF50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Save",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Edit Profile',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF584A4A),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "My Bio",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF584A4A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Name",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF584A4A),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 400,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA0D7C8).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_2_outlined,
                              color: Color(0xFF584141),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              usernameDisplay,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF584A4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Bio",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF584A4A),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 400,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFFA0D7C8).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              color: Color(0xFF584141),
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              bioDisplay,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF584A4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Birth Date",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF584A4A),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 400,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFFA0D7C8).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: Color(0xFF584141),
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formattedBirthDate,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF584A4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Number Phone",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF584A4A),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 400,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFFA0D7C8).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.smartphone_outlined,
                              color: Color(0xFF584141),
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              noTelDisplay,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF584A4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _logOut(context),
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      "Log Out",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

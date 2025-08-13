import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projek2_aplikasi_todolist/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projek2_aplikasi_todolist/widgets/category.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleTaskController = TextEditingController();
  final _notesTaskController = TextEditingController();

  String formattingCategory(String category) {
    return category.trim().toLowerCase().replaceAll(" ", "_");
  }

  final Map<String, int> mappingPriority = {
    'High': 1,
    'Mid': 2,
    'Low': 3,
  };

  final List<String> listPriority = [
    'High',
    'Mid',
    'Low',
  ];

  String? kategoriTerpilih;
  String? prioritasTerpilih;

  DateTime? tanggalTerpilih;
  TimeOfDay? waktuTerpilih;

  String get formatTanggal {
    if (tanggalTerpilih == null) return '';
    return DateFormat('MMMM d, yyyy')
        .format(tanggalTerpilih!); // Format cth: July 27, 2025
  }

  String get formatWaktu {
    if (waktuTerpilih == null) return '';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, waktuTerpilih!.hour,
        waktuTerpilih!.minute);
    return DateFormat('HH:mm').format(dt); // Format cth: 12:00
  }

  Future<void> addNewTask() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      if (uid == null) throw Exception("User belum login");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .add({
        'title': _titleTaskController.text.trim(),
        'category': kategoriTerpilih != null
            ? formattingCategory(kategoriTerpilih!)
            : null,
        'priority': prioritasTerpilih != null
            ? mappingPriority[prioritasTerpilih!]
            : null,
        'date': tanggalTerpilih != null
            ? Timestamp.fromDate(tanggalTerpilih!)
            : null,
        'time': waktuTerpilih != null
            ? formatWaktu
            : null,
        'notes': _notesTaskController.text,
        'status': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      successShowTopSnackBar(context, "Task added successfully.");
    } catch (_) {
      failedShowTopSnackBar(context, "Failed adding task.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian atas (judul + tanggal)
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
                      icon: Icon(Icons.arrow_back_ios_new_rounded)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Add New Task',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF584A4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Form Code
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TASK TITLE
                        Text(
                          "Task Title",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF584A4A),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _titleTaskController,
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                          ),
                          decoration: InputDecoration(
                            hintText: "Input your task title",
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Color(0xFF584A4A),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Color(0xFFA0D7C8),
                            filled: true,
                          ),
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Title wajib diisi";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),

                        // KATEGORI
                        Text(
                          "Category",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF584A4A),
                          ),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: kategoriTerpilih,
                          hint: Text(
                            "Select Category",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Color(0xFF584A4A),
                            ),
                          ),
                          items: listCategory
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => kategoriTerpilih = value),
                          decoration: InputDecoration(
                            fillColor: Color(0xFFA0D7C8),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Pilih kategori";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),

                        // PRIORITAS
                        Text(
                          "Priority",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF584A4A),
                          ),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: prioritasTerpilih,
                          hint: Text(
                            "Select Priority",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Color(0xFF584A4A),
                            ),
                          ),
                          items: listPriority
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => prioritasTerpilih = value),
                          decoration: InputDecoration(
                            fillColor: Color(0xFFA0D7C8),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Pilih prioritas";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),

                        // DATE AND TIME
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date",
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF584A4A),
                                    ),
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: formatTanggal),
                                    decoration: InputDecoration(
                                      fillColor: Color(0xFFA0D7C8),
                                      filled: true,
                                      suffixIcon: Icon(Icons.calendar_month),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onTap: () async {
                                      final DateTime? terpilih =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            tanggalTerpilih ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );
                                      if (terpilih != null) {
                                        setState(() {
                                          tanggalTerpilih = terpilih;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Time",
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF584A4A),
                                    ),
                                  ),
                                  TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: formatWaktu),
                                    decoration: InputDecoration(
                                      fillColor: Color(0xFFA0D7C8),
                                      filled: true,
                                      suffixIcon: Icon(Icons.access_time),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onTap: () async {
                                      final TimeOfDay? terpilih =
                                          await showTimePicker(
                                        context: context,
                                        initialTime:
                                            waktuTerpilih ?? TimeOfDay.now(),
                                      );
                                      if (terpilih != null) {
                                        setState(() {
                                          waktuTerpilih = terpilih;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                        // NOTES
                        SizedBox(height: 10),
                        Text(
                          "Notes",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF584A4A),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _notesTaskController,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            color: Color(0xFF584A4A),
                          ),
                          decoration: InputDecoration(
                            hintText: "Input your notes (optional)",
                            hintStyle: GoogleFonts.poppins(fontSize: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Color(0xFFA0D7C8),
                            filled: true,
                          ),
                          maxLines: 6,
                        ),
                        SizedBox(height: 35),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await addNewTask();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF584A4A),
                              backgroundColor: const Color(0xFFA0D7C8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            child: Text(
                              "Save",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                color: Color(0xFF584A4A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

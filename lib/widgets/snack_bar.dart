import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void successShowTopSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Material(
        elevation: 10,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Color(0xFF5DEE4F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF15FF00), width: 4),
          ),
          child: Center(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  // Masukkan overlay-nya
  overlay.insert(overlayEntry);

  // Hapus setelah 2 detik
  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

void failedShowTopSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Material(
        elevation: 10,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Color(0xFFFF6B6B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFFF0000), width: 4),
          ),
          child: Center(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  // Masukkan overlay-nya
  overlay.insert(overlayEntry);

  // Hapus setelah 2 detik
  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
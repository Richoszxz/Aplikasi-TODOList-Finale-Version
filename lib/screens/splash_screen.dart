import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projek2_aplikasi_todolist/widgets/snack_bar.dart';

// REGISTER BOTTOM MODAL SHEET
class RegisterModalSheet extends StatefulWidget {
  const RegisterModalSheet({super.key});

  @override
  State<RegisterModalSheet> createState() => _RegisterModalSheetState();
}

class _RegisterModalSheetState extends State<RegisterModalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _noteleponController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();
  bool _isLoading = false;

  // FUNGSI HANDLER REGISTER SUBMIT KE DATABASE
  Future<void> _register() async {
    if (_konfirmasiPasswordController.text != _passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password tidak sama!"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // GET USER ID
      String userId = userCredential.user!.uid;

      // MAPPING COLLECTION DAN DOC ID SESUAI USER ID PADA CLOUD FIRESTORE
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'noTelepon': _noteleponController.text.trim(),
        'bio': '',
        'tanggalLahir': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
      successShowTopSnackBar(context, "Register Berhasil !");
    } on FirebaseAuthException catch (_) {
      failedShowTopSnackBar(context, "Register Gagal, Silahkan Coba Lagi !");
    }
    setState(() => _isLoading = false);
  }

  bool _isObscurePass = true;
  bool _isObscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity, // penuh layar
          decoration: BoxDecoration(
            color: Color(0xFFA0D7C8),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            // biar kalau form panjang bisa discroll
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 30,
              left: 16,
              right: 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Create Account',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF584A4A),
                    ),
                  ),
                  SizedBox(height: 25),
                  // Username
                  _buildTextField(
                    controller: _usernameController,
                    label: "username",
                    hint: "Hirai Momo",
                  ),
                  SizedBox(height: 20),
                  // Email
                  _buildTextField(
                    controller: _emailController,
                    label: "email",
                    hint: "infoexample.com",
                  ),
                  SizedBox(height: 20),
                  // No Telepon
                  _buildTextField(
                    controller: _noteleponController,
                    label: "no telepon",
                    hint: "08123456789",
                  ),
                  SizedBox(height: 20),
                  // Password
                  _buildTextField(
                    controller: _passwordController,
                    label: "password",
                    hint: "password",
                    obscure: _isObscurePass,
                    toggle: () {
                      setState(() => _isObscurePass = !_isObscurePass);
                    },
                  ),
                  SizedBox(height: 20),
                  // Confirm Password
                  _buildTextField(
                    controller: _konfirmasiPasswordController,
                    label: "confirm password",
                    hint: "confirm password",
                    obscure: _isObscureConfirm,
                    toggle: () {
                      setState(() => _isObscureConfirm = !_isObscureConfirm);
                    },
                  ),
                  SizedBox(height: 20),
                  // Register Button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _register();
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            "Register",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFFA0D7C8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(double.infinity, 55), // full lebar
                      elevation: 0,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have account?',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF584A4A)),
                      ),
                      Text(
                        ' Login',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: toggle != null
              ? InkWell(
                  onTap: toggle,
                  child: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                    size: 26,
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red, width: 3.0),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }
}

// LOGIN BOTTOM MODAL SHEET
class LoginModalSheet extends StatefulWidget {
  const LoginModalSheet({super.key});

  @override
  State<LoginModalSheet> createState() => _LoginModalSheetState();
}

class _LoginModalSheetState extends State<LoginModalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
      successShowTopSnackBar(context, "Login Berhasil");
    } on FirebaseAuthException catch (_) {
      failedShowTopSnackBar(context, "Login Gagal, Silahkan Coba Lagi !");
    }
    setState(() => _isLoading = false);
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity, // full
          decoration: BoxDecoration(
            color: Color(0xFFA0D7C8),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 30,
              left: 16,
              right: 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF584A4A),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildLoginField(
                    controller: _emailController,
                    label: "Username/email",
                    hint: "ricko11@gmail.com",
                  ),
                  SizedBox(height: 20),
                  _buildLoginField(
                    controller: _passwordController,
                    label: "password",
                    hint: "12345678",
                    obscure: _isObscure,
                    toggle: () {
                      setState(() => _isObscure = !_isObscure);
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            "Login",
                            style: GoogleFonts.poppins(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFFA0D7C8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minimumSize: Size(double.infinity, 55),
                      elevation: 0,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account?',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF584A4A),
                        ),
                      ),
                      Text(
                        ' Register',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLoginField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: toggle != null
              ? InkWell(
                  onTap: toggle,
                  child: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                    size: 26,
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red, width: 3.0),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'NexToDo',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA0D7C8),
                  ),
                ),
                const SizedBox(height: 25),
                ClipOval(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA0D7C8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 10,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'Logo.png',
                        width: MediaQuery.of(context).size.width * 0.4,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    Text(
                      'Get organized  your life',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF584A4A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'simple and affective\n'
                      'to-do list and task manager app\n'
                      'which helps you manage time\n',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF584A4A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Create Account
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (_) => const RegisterModalSheet());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: const BoxDecoration(
                          color: Color(0xFFA0D7C8),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            'Create Account',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF584A4A),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // END Create Account

                const SizedBox(height: 40),

                // Login
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (_) => const LoginModalSheet());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFFA0D7C8),
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFA0D7C8),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                // END LOGIN
              ],
            ),
          ),
        ),
      ),
    );
  }
}

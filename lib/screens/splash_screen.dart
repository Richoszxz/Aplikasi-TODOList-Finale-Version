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
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // GET USER ID
      String userId = userCredential.user!.uid;

      // MAPPING COLLECTION DAN DOC ID SESUAI USER ID PADA CLOUD FIRESTORE
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username' : _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'noTelepon' : _noteleponController.text.trim(),
        'bio' : '',
        'tanggalLahir' : null,
        'createdAt' : FieldValue.serverTimestamp(),
        'updatedAt' : FieldValue.serverTimestamp(),
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
          width: 440,
          height: 650,
          decoration: BoxDecoration(
            color: Color(0xFFA0D7C8),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'Create Account',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF584A4A),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextFormField(
                    controller: _usernameController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      hintText: "Hirai Momo",
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "username",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 3.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wajib diisi";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      hintText: "infoexample.com",
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "email",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 3.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wajib diisi";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextFormField(
                    controller: _noteleponController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      hintText: "08123456789",
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "no telepon",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 3.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wajib diisi";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscurePass,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      hintText: "password",
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "password",
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _isObscurePass = !_isObscurePass;
                          });
                        },
                        child: Icon(
                          _isObscurePass ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 3.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wajib diisi";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextFormField(
                    controller: _konfirmasiPasswordController,
                    obscureText: _isObscureConfirm,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      hintText: "confirm password",
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "confirm password",
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _isObscureConfirm = !_isObscureConfirm;
                          });
                        },
                        child: Icon(
                          _isObscureConfirm ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 3.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wajib diisi";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : () {
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
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                    minimumSize: Size(400, 60),
                    elevation: 0,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                      'Login',
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
      ],
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
          height: 400,
          decoration: BoxDecoration(
            color: Color(0xFFA0D7C8),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF584A4A),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      hintText: "ricko11@gmail.com",
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "Username/email",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 3.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wajib diisi";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 400,
                  height: 60,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 3.0),
                      ),
                      hintText: "12345678",
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "password",
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        child: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 3.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Wajib diisi";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : () {
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
                      borderRadius: BorderRadiusGeometry.circular(20)
                    ),
                    minimumSize: Size(400, 60),
                    elevation: 0,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                      'Register',
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
        )
      ],
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
        child: Center(
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
                ClipOval(
                  child: Container(
                    width: 326,
                    height: 282,
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
                        width: 195,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 90, vertical: 20),
                        decoration: const BoxDecoration(
                          color: Color(0xFFA0D7C8),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
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
                  ],
                ),
                // END Create Account

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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 150, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFFA0D7C8),
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFA0D7C8),
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

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

// REGISTER BOTTOM MODAL SHEET
class RegisterModalSheet extends StatefulWidget {
  const RegisterModalSheet({super.key});

  @override
  State<RegisterModalSheet> createState() => _RegisterModalSheetState();
}

class _RegisterModalSheetState extends State<RegisterModalSheet> {
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Register Gagal !"),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: 440,
          height: 550,
          decoration: BoxDecoration(
            color: Color(0xFFA0D7C8),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
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
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    hintText: "infoexample.com",
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: "username/email",
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
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                height: 60,
                child: TextField(
                  controller: _noteleponController,
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
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                height: 60,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    hintText: "password",
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: "password",
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.visibility_outlined,
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
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                height: 60,
                child: TextField(
                  controller: _konfirmasiPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    hintText: "confirm password",
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: "confirm password",
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.visibility_outlined,
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
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
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
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login Gagal !"),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

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
                child: TextField(
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
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                height: 60,
                child: TextField(
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
                      onTap: () {},
                      child: Icon(
                        Icons.visibility_outlined,
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
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ));
                },
                child: Container(
                  width: 400,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color(0xFF584A4A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
        )
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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

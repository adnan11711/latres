import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool obscurePass = true;

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedUser = prefs.getString("username");
    String? savedPass = prefs.getString("password");

    if (username.text == savedUser && password.text == savedPass) {
      prefs.setBool("isLogin", true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(username: savedUser!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login gagal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔵 Background gradient seperti gambar
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffd7efff),
              Color(0xffa7d8ff),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            const Text(
              "Silahkan Login Sayang...",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TextField(
                controller: username,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email_outlined),
                  border: InputBorder.none,
                  hintText: "Email",
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔒 TextField Password + Hide/Show
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TextField(
                controller: password,
                obscureText: obscurePass,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock_outline),
                  border: InputBorder.none,
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePass
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => obscurePass = !obscurePass);
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔵 Tombol Sign In
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔵 Link Daftar Sekarang
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Daftar Sekarang",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

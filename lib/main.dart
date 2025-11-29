import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Cek apakah pengguna sudah login
  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }

 Future<String> getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String name = prefs.getString("username") ?? "User";

  // Hilangkan @... dari email
  if (name.contains("@")) {
    name = name.split("@")[0];
  }

  return name;
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsi PAM',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),

      // Gunakan FutureBuilder untuk menentukan halaman awal
      home: FutureBuilder(
        future: checkLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Jika sudah login → arahkan ke HomePage dengan username
          if (snapshot.data == true) {
            return FutureBuilder(
              future: getUsername(),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox();
                return HomePage(username: snap.data!);
              },
            );
          }

          // Jika belum login → ke LoginPage
          return const LoginPage();
        },
      ),
    );
  }
}

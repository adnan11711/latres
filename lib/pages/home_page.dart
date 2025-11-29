import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'list_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart'; // ➕ tambahkan import profile

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  String cleanUsername(String name) {
    if (name.contains("@")) {
      return name.split("@")[0];
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeContent(username: cleanUsername(widget.username)), // Home
      FavoritePage(),                                       // Favorite
      ProfilePage(),                                        // ➕ Profile
    ];

    return Scaffold(
      body: pages[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey.shade600,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"), // ➕ Profile
        ],
      ),
    );
  }
}

// ===========================================================================
//                                 HOME CONTENT
// ===========================================================================

class HomeContent extends StatelessWidget {
  final String username;

  const HomeContent({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text("Hai, $username!"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("isLogin", false);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          )
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffe7f3ff),
              Color(0xffcfe7ff),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(
          child: Column(
            children: [
              homeMenuCard(
                context,
                title: "News",
                description:
                    "Get an overview of the latest SpaceFlight news, from various sources! Easily link your users to the right websites",
                image: "assets/news.png",
                menu: "articles",
              ),
              SizedBox(height: 20),
              homeMenuCard(
                context,
                title: "Blog",
                description:
                    "Blogs often provide a more detailed overview of launches and missions. A must-have for the serious spaceflight enthusiast",
                image: "assets/blog.jpeg",
                menu: "blogs",
              ),
              SizedBox(height: 20),
              homeMenuCard(
                context,
                title: "Report",
                description:
                    "Space stations and other missions often publish their data. With SNAP!, you can include it in your app!",
                image: "assets/report.png",
                menu: "reports",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
//                                 CARD COMPONENT
// ===========================================================================

Widget homeMenuCard(
  BuildContext context, {
  required String title,
  required String description,
  required String image,
  required String menu,
}) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Image.asset(image, width: 70),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  ).onTap(() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListPage(menu: menu, title: title),
      ),
    );
  });
}

// ===========================================================================
//                              TAP EXTENSION
// ===========================================================================

extension OnTapContainer on Widget {
  Widget onTap(Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}

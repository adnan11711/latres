import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/article.dart';
import 'detail_page.dart';

class ListPage extends StatelessWidget {
  final String menu;
  final String title;

  const ListPage({super.key, required this.menu, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔵 AppBar biru
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),

      // 🔵 Background gradient seperti login/home
      body: Container(
        width: double.infinity,
        height: double.infinity,
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

        child: FutureBuilder(
          future: ApiService().fetchData(menu),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Article> data = snapshot.data ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: data.length,
              itemBuilder: (_, i) {
                Article a = data[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,           // 🤍 card putih
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    // 🖼️ gambar
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        a.imageUrl,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // 📝 judul biru gelap
                    title: Text(
                      a.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue.shade900,
                      ),
                    ),

                    // 📅 tanggal abu-abu
                    subtitle: Text(
                      a.publishedAt,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(menu: menu, id: a.id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

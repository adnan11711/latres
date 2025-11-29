import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/article.dart';
import '../services/favorite_service.dart';
import '../models/favorite_item.dart';

class DetailPage extends StatefulWidget {
  final String menu;
  final int id;

  const DetailPage({super.key, required this.menu, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    final favorites = await FavoriteService.getFavorites();
    setState(() {
      isFavorite = favorites.any((item) => item.id == widget.id);
    });
  }

  Future<void> toggleFavorite(Article a) async {
    if (isFavorite) {
      final list = await FavoriteService.getFavorites();
      final index = list.indexWhere((item) => item.id == a.id);

      if (index != -1) {
        await FavoriteService.removeAt(index);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${a.title} dihapus dari Favorite")),
      );
    } else {
      final fav = FavoriteItem(
        id: a.id,
        title: a.title,
        imageUrl: a.imageUrl,
        menu: widget.menu,
      );

      await FavoriteService.addFavorite(fav);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${a.title} ditambahkan ke Favorite")),
      );
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7f3ff), // 💙 full background biru lembut

      // 🔵 AppBar biru
      appBar: AppBar(
        title: const Text("Detail"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,

        // ❤️ Icon favorite berubah merah
        actions: [
          FutureBuilder(
            future: ApiService().fetchDetail(widget.menu, widget.id),
            builder: (_, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              Article a = snapshot.data!;

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () => toggleFavorite(a),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.open_in_new),
        onPressed: () async {
          Article a = await ApiService().fetchDetail(widget.menu, widget.id);
          launchUrl(Uri.parse(a.url));
        },
      ),

      // 🔵 BACKGROUND FULL BIRU LEMBUT
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffe7f3ff),

        child: FutureBuilder(
          future: ApiService().fetchDetail(widget.menu, widget.id),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            Article a = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🤍 CARD PUTIH UTAMA
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GAMBAR
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(a.imageUrl),
                        ),

                        const SizedBox(height: 15),

                        
                        Text(
                          a.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🗓️ TANGGAL
                        Text(
                          a.publishedAt,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 📄 SUMMARY
                        Text(
                          a.summary,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30), // ruang bawah biar tidak mepet
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

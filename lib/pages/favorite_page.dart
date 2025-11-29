import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../models/favorite_item.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<FavoriteItem> items = [];

  @override
  void initState() {
    super.initState();
    loadFavorite();
  }

  Future<void> loadFavorite() async {
    final data = await FavoriteService.getFavorites();
    setState(() => items = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔵 AppBar warna biru
      appBar: AppBar(
        title: const Text("Favorite"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),

      // 🔵 Background gradient biru lembut
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

        child: items.isEmpty
            ? const Center(
                child: Text(
                  "Belum ada favorite",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];

                  return Dismissible(
                    key: Key(item.id.toString()),
                    direction: DismissDirection.horizontal,

                    onDismissed: (direction) async {
                      await FavoriteService.removeAt(i);
                      loadFavorite();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${item.title} dihapus dari favorite"),
                        ),
                      );
                    },

                    // 🔴 Background ketika swipe delete
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),

                    secondaryBackground: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),

                    // 🤍 Card Putih Rounded
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),

                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item.imageUrl,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),

                        title: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),

                        subtitle: Text(
                          item.menu.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_item.dart';

class FavoriteService {
  static const String key = "favorites";

  // Ambil semua favorite
  static Future<List<FavoriteItem>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);

    if (data == null) return [];

    List jsonList = jsonDecode(data);
    return jsonList.map((e) => FavoriteItem.fromJson(e)).toList();
  }

  // Tambah favorite
  static Future<void> addFavorite(FavoriteItem item) async {
    final list = await getFavorites();
    list.add(item);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  // Hapus favorite berdasarkan index
  static Future<void> removeAt(int index) async {
    final list = await getFavorites();
    list.removeAt(index);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }
}

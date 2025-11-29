import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  Future<List<Article>> fetchData(String menu) async {
    final url = "https://api.spaceflightnewsapi.net/v4/$menu/";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body)['results'];
      return data.map((e) => Article.fromJson(e)).toList();
    }
    throw Exception("Failed to load data");
  }

  Future<Article> fetchDetail(String menu, int id) async {
    final url = "https://api.spaceflightnewsapi.net/v4/$menu/$id/";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return Article.fromJson(jsonDecode(res.body));
    }
    throw Exception("Failed to load detail");
  }
}

class FavoriteItem {
  final int id;
  final String title;
  final String imageUrl;
  final String menu; // articles, blogs, reports

  FavoriteItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.menu,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "imageUrl": imageUrl,
        "menu": menu,
      };

  static FavoriteItem fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json["id"],
      title: json["title"],
      imageUrl: json["imageUrl"],
      menu: json["menu"],
    );
  }
}

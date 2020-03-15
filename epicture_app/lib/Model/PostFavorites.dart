class MyPostFavorites {
  final List<dynamic> data;

  MyPostFavorites({this.data});

  factory MyPostFavorites.fromJson(Map<String, dynamic> json) {
    return MyPostFavorites(
      data: json['data'],
    );
  }
}
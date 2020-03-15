class MyPostList {
  final List<dynamic> data;

  MyPostList({this.data});

  factory MyPostList.fromJson(Map<String, dynamic> json) {
    return MyPostList(
      data: json['data'],
    );
  }
}
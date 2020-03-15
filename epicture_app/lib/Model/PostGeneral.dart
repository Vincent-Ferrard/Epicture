class MyPostGeneral {
  final List<dynamic> data;

  MyPostGeneral({this.data});

  factory MyPostGeneral.fromJson(Map<String, dynamic> json) {
    return MyPostGeneral(
      data: json['data'],
    );
  }
}
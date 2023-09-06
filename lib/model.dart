class TestApi {
  int? userId;
  int? id;
  String? title;
  String? body;

  TestApi({this.userId, this.id, this.title, this.body});

  TestApi.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = this.body;
    return data;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import "package:http/http.dart" as http;

// ignore: must_be_immutable
class MyApi extends StatelessWidget {
  MyApi({super.key});

  final String Url = "https://jsonplaceholder.typicode.com/photos";

  List<Model> itemList = [];
  Future<List<Model>> getdata() async {
    final response = await http.get(Uri.parse(Url));
    var datas = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in datas) {
        itemList.add(Model.fromJson(i));
      }
      return itemList;
    } else {
      return itemList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text("My App"))),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getdata(),
                  builder: ((context, snapshot) {
                    return ListView.builder(
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data![index].title.toString()),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(itemList[index].url.toString()),
                            ),
                          );
                        });
                  })),
            )
          ],
        ));
  }
}

class Model {
  int? id;
  String? title;
  String? url;

  Model({
    required this.id,
    required this.title,
    required this.url,
  });

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
  }
}

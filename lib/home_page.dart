import 'dart:convert';

import 'package:apitest/model.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:velocity_x/velocity_x.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TestApi> apiList = [];

  Future<List<TestApi>> getApi() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        apiList.add(TestApi.fromJson(i));
      }
      return apiList;
    } else {
      return apiList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Test Api")),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getApi(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                        itemCount: apiList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Id: ${apiList[index].id.toString()}"),
                                    Text(
                                      "Title: ${apiList[index].title.toString()}",
                                    ),
                                    Text(
                                        "Body: ${apiList[index].body.toString()}")
                                  ]),
                            ),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }
}

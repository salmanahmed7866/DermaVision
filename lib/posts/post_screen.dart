import 'package:apitest/login_page.dart';
import 'package:apitest/posts/add_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

final auth = FirebaseAuth.instance;

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Post");
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("$error")));
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
                hintText: "Search", border: OutlineInputBorder()),
            onChanged: (String value) {
              setState(() {
                searchFilter.text = value;
              });
            },
          ),
        ),
        Expanded(
            child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: const CircularProgressIndicator());
                  } else {
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list = map.values.toList();

                    return ListView.builder(
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: ((context, index) {
                        final title = list[index]['title'].toString();
                        final id = list[index]['id'].toString();

                        if (searchFilter.text.isEmpty) {
                          return ListTile(
                              title: Text(title),
                              subtitle: Text(list[index]['id'].toString()),
                              trailing: PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: ((context) => [
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showMyDialog(title, id);
                                            },
                                            leading: Icon(Icons.edit),
                                            title: Text("Edit"),
                                          )),
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              deleteData(id);
                                              //ref.child(id).remove();
                                            },
                                            leading: Icon(Icons.delete),
                                            title: Text("Delete"),
                                          ))
                                    ]),
                              ));
                        } else if (title
                            .toLowerCase()
                            .contains(searchFilter.text.toLowerCase())) {
                          return ListTile(
                            title: Text(title),
                            subtitle: Text(list[index]['id'].toString()),
                          );
                        } else {
                          return SizedBox(); // Return an empty widget if it doesn't match the search filter.
                        }
                      }),
                    );
                  }
                }))
      ]),
      //  FirebaseAnimatedList(
      //       query: ref,
      //       itemBuilder: (context, snapshot, animation, index) {
      //         return ListTile(
      //           title: Text(snapshot.child('title').value.toString()),
      //           subtitle: Text(snapshot.child('id').value.toString()),
      //         );
      //       },
      //     ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(hintText: "Edit"),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update(
                      {"title": editController.text.toString()}).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Successfully Added"),
                      backgroundColor: Colors.deepOrange,
                    ));
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Unfortunately Not Added"),
                      backgroundColor: Colors.deepOrange,
                    ));
                  });
                },
                child: Text("Update"),
              )
            ],
          );
        });
  }

  Future<void> deleteData(String id) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure"),
            content: Container(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).remove().then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Successfully Added"),
                      backgroundColor: Colors.deepOrange,
                    ));
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Unfortunatley Not Added"),
                      backgroundColor: Colors.deepOrange,
                    ));
                  });
                },
                child: Text("Yes"),
              )
            ],
          );
        });
  }
}

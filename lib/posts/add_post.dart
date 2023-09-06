import 'package:apitest/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

final postController = TextEditingController();
bool loading = false;
final databaseRef = FirebaseDatabase.instance.ref("Post");

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Add Post")),
      ),
      body: Column(children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: "What is in your mind?",
                  border: OutlineInputBorder())),
        ),
        const SizedBox(
          height: 20,
        ),
        RoundedButton(
            title: "Add",
            loading: loading,
            onTap: () {
              setState(() {
                loading = true;
              });
              String id = DateTime.now().millisecondsSinceEpoch.toString();
              databaseRef.child(id).set({
                "id": id,
                "title": postController.text.toString(),
              }).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Successfully Added"),
                  backgroundColor: Colors.deepOrange,
                ));
                setState(() {
                  loading = false;
                });
              }).onError((error, stackTrace) {
                setState(() {
                  loading = false;
                });
              });
            })
      ]),
    );
  }
}

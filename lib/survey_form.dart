import 'package:apitest/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
//import "package:velocity_x/velocity_x.dart";

class Survey extends StatefulWidget {
  Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String pet = "Dog";
  bool isOk = false;
  String tokenofapi = "";
  String symptoms = "";
  String yob = "";
  String gender = "";

  void fetchData() async {
    final token = await authenticate();
  }

  Future authenticate() async {
    String uri = "https://authservice.priaid.ch/login";
    String api_key = "Ry9w7_GMAIL_COM_AUT";
    String secret_key = "Qo94Jaz7SGr6m3E2M";
    final secretBytes = utf8.encode(secret_key);
    String computedHashString = "";

    Hmac hmac = Hmac(md5, secretBytes);
    final dataBytes = utf8.encode(uri);
    final computedHash = hmac.convert(dataBytes).bytes;
    computedHashString = base64.encode(computedHash);

    var headers = {
      "Authorization": "Bearer $api_key:$computedHashString",
    };

    try {
      http.Response response =
          await http.post(Uri.parse(uri), headers: headers, body: "");
      String responseArray = response.body;

      final apitoken = jsonDecode(responseArray)["Token"];
      tokenofapi = apitoken.toString();

      print(apitoken);

      // Deserialize token string
    } catch (e) {
      String errorMessage = e.toString();
      // Exception is in errorMessage
    }
  }

  void displayDiagnosis() async {
    final diagnosis =
        'https://healthservice.priaid.ch/diagnosis?token=$tokenofapi&language=en-gb&symptoms=$symptoms&gender=$gender&year_of_birth=$yob';
  }

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Survey Form")),
          backgroundColor: Colors.deepPurple.shade300,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding:
                        const EdgeInsets.only(left: 2, bottom: 10, top: 20),
                    child: Text("Gender:")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RadioListTile(
                          title: Text("Male"),
                          value: "Cat",
                          groupValue: pet,
                          contentPadding: EdgeInsets.all(0.0),
                          dense: true,
                          tileColor: Colors.purple.shade100,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          onChanged: (value) {
                            setState(() {
                              pet = value.toString();
                            });
                          }),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: RadioListTile(
                          title: Text("Female"),
                          value: "Dog",
                          dense: true,
                          contentPadding: EdgeInsets.all(0.0),
                          tileColor: Colors.purple.shade100,
                          groupValue: pet,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          visualDensity: VisualDensity.compact,
                          onChanged: (value) {
                            setState(() {
                              pet = value.toString();
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text("Age:"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Enter Age",
                      labelStyle: TextStyle(color: Colors.purple.shade200),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      hintText: "age",
                      icon: Icon(Icons.date_range_outlined,
                          color: Colors.purple.shade200, size: 28)),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Select From Following Issue",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Column(
                          children: [
                            CheckboxListTile(
                              value: isOk,
                              onChanged: (value) {
                                setState(() {});
                              },
                              title: Text('Skin Rash'),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              value: isOk,
                              onChanged: (value) {
                                setState(() {});
                              },
                              title: Text('Skin Redness'),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              value: isOk,
                              onChanged: (value) {
                                setState(() {});
                              },
                              title: Text('Skin Lesion'),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            CheckboxListTile(
                              value: isOk,
                              onChanged: (value) {
                                setState(() {});
                              },
                              title: Text('Skin Nodules'),
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Select the Visibility of your skin:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          children: [
                            RadioListTile(
                                value: "visible",
                                title: Text("No Visible coloring on skin spot"),
                                groupValue: isOk,
                                onChanged: (value) {
                                  setState(() {});
                                }),
                            RadioListTile(
                                value: "isOk",
                                title: Text("Blue Colored Skin"),
                                groupValue: isOk,
                                onChanged: (value) {
                                  setState(() {});
                                }),
                            RadioListTile(
                                value: "jjb",
                                title: Text("Blue Spot on Skin"),
                                groupValue: isOk,
                                onChanged: (value) {
                                  setState(() {});
                                }),
                            RadioListTile(
                                value: isOk,
                                title: Text("Yellow Colored Skin"),
                                groupValue: isOk,
                                onChanged: (value) {
                                  setState(() {});
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Select the Visibility of your skin:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          children: [
                            RadioListTile(
                                value: "visible",
                                title: Text("No Visible coloring on skin spot"),
                                groupValue: isOk,
                                onChanged: (value) {
                                  setState(() {});
                                }),
                            RadioListTile(
                                value: "isOk",
                                title: Text("Blue Colored Skin"),
                                groupValue: isOk,
                                onChanged: (value) {
                                  setState(() {});
                                }),
                            RadioListTile(
                                value: "jjb",
                                title: Text("Blue Spot on Skin"),
                                groupValue: isOk,
                                onChanged: (value) {
                                  setState(() {});
                                }),
                            RadioListTile(
                                value: isOk,
                                title: Text("Yellow Colored Skin"),
                                groupValue: isOk,
                                onChanged: (value) {
                                  setState(() {});
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

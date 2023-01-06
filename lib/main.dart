import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum(
    String instruction, String text, String textTwo) async {
  Map<String, dynamic> body = {
    "model": "text-davinci-003",
    "prompt":
        "Write a recipe based on these ingredients and instructions:\n\n$instruction\n\nIngredients:\n$text\n$textTwo",
    "temperature": 0.3,
    "max_tokens": 120,
    "top_p": 1.0,
    "frequency_penalty": 0.0,
    "presence_penalty": 0.0
  };
  String jsonBody = jsonEncode(body);
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/completions'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer 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'
    },
    body: jsonBody,
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String id;
  final String text;

  const Album({
    required this.id,
    required this.text,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    var recipie;
    json['choices'].forEach((element) {
      recipie = (element['text']);
    });

    return Album(
      id: json['id'],
      text: recipie,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _textTwoController = TextEditingController();
  final _instructionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum('', '', '');
  }

  fetchData(String instruction, String text, String textWo) {
    // Make the API call and update _dataFuture
    setState(() {
      futureAlbum = fetchAlbum(instruction, text, textWo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Get Recipie From Ingredients'),
          backgroundColor: Colors.red[500],
          elevation: 0,
          leading: const Icon(Icons.food_bank),
        ),
        backgroundColor: Colors.red[200],
        bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 244, 67, 54)),
              label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 244, 67, 54)),
              label: 'home'),
          BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(255, 244, 67, 54),
              icon: Icon(
                Icons.home,
                color: Color.fromARGB(255, 244, 67, 54),
              ),
              label: 'home')
        ]),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Container(
                  //   height: 300,
                  //   width: 300,
                  //   decoration: BoxDecoration(
                  //       color: Colors.red[100],
                  //       border: Border.all(color: Colors.white),
                  //       borderRadius: BorderRadius.circular(12),
                  //       image: const DecorationImage(
                  //         image: NetworkImage(
                  //           'https://picsum.photos/id/1074/400/400',
                  //         ),
                  //       )),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextFormField(
                            controller: _instructionController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some instructions';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Instructions')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextFormField(
                            controller: _textController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ingredient one')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextFormField(
                            controller: _textTwoController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ingredient two')),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromARGB(255, 253, 254, 255),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          child: FutureBuilder<Album>(
                            future: futureAlbum,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // If the API call was successful, display the data in the card
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(snapshot.data!.text),
                                );
                              } else if (snapshot.hasError) {
                                // If the API call returned an error, display an error message
                                return Text('${snapshot.error}');
                              }
                              return Text('${snapshot.error}');
                              // While the API call is in progress, display a loading indicator
                              // return const CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[500],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Make the API call and print the response
                        fetchData(_instructionController.text,
                                _textController.text, _textTwoController.text)
                            .then((response) {});
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: const FloatingActionButton(
          tooltip: 'Add', // used by assistive technologies
          onPressed: null,
          backgroundColor: Color.fromARGB(255, 218, 81, 72),
          child: Icon(
            Icons.add,
            color: Color.fromARGB(255, 173, 18, 7),
          ),
        ),
      ),
    );
  }
}

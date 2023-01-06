import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  Map<String, dynamic> body = {
    "model": "text-davinci-003",
    "prompt":
        "Write a recipe based on these ingredients and instructions:\n\nchillie\n\nIngredients:\njackfruit",
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

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
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
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  elevation: 5,
                );
                // return Text(snapshot.data!.text);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

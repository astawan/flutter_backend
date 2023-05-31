import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_backend/mahasiswa.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Mahasiswa>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchData();
  }

  Future<List<Mahasiswa>> fetchData() async {
    List<Mahasiswa> mahasiswas = [];
    final response = await http.get(Uri.parse('http://localhost:3000/all-mahasiswa'));

    if (response.statusCode == 200) {
      List<dynamic> resJson = jsonDecode(response.body);
      for (var element in resJson) {
        mahasiswas.add(Mahasiswa.fromJson(element));
      }
      return mahasiswas;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Mahasiswa>>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return Column(
                      children: [
                        Text(snapshot.data![index].id.toString()),
                        Text(snapshot.data![index].nama.toString()),
                      ],
                    );
                  }));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

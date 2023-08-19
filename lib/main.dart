import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe APP Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecipeScreen(),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<dynamic> songs = [];

  Future fetchsongs() async {
    final response = await http.get(Uri.parse(
        'http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist=Taylor Swift&api_key=c752c873a2b49d4fdd3c7f0729d5f0dc&format=json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        songs = data['topalbums']['album'];
      });
    } else {
      setState(() {
        songs = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Charts',
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.greenAccent.shade700),
              child: const Center(
                  child: Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 30,
              )),
            )
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder(
              future: fetchsongs(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      leading: Image.network(
                        song['image'][1]['#text'],
                        width: 60,
                        height: 80,
                      ),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              song['name'],
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                          song['artist']['name'] ?? 'data not available',
                          style: GoogleFonts.poppins(
                              color: Colors.white60,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

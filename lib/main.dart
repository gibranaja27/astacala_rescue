import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:astacala_rescue/notifikasi.dart';
import 'package:astacala_rescue/form_pelaporan.dart';
import 'package:astacala_rescue/detail_berita_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita Bencana',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List berita = [];

  Future<void> fetchBerita() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/berita-bencana'));

    if (response.statusCode == 200) {
      setState(() {
        berita = json.decode(response.body);
      });
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBerita();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Bencana'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigasi ke halaman Notifikasi
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotifikasiPage(
                          penggunaId: 1,
                        )),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: berita.length,
        itemBuilder: (context, index) {
          final item = berita[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['pblk_foto_bencana'] != null)
                  Image.network(
                    'http://10.0.2.2:8000/storage/${item['pblk_foto_bencana']}',
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item['pblk_judul_bencana'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBeritaPage(
                          id: int.parse(item['id'].toString()),
                        ),
                      ),
                    );
                  },
                  child: const Text('Lihat Detail'),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // index tab aktif, ganti sesuai logika
        onTap: (index) {
          // handle klik tab di sini
          if (index == 0) {
            // Sudah di HomePage, ga perlu pindah
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FormPelaporanPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Pelaporan',
          ),
        ],
      ),
    );
  }
}

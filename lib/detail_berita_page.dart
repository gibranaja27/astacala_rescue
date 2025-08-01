import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailBeritaPage extends StatefulWidget {
  final int id;
  const DetailBeritaPage({super.key, required this.id});

  @override
  State<DetailBeritaPage> createState() => _DetailBeritaPageState();
}

class _DetailBeritaPageState extends State<DetailBeritaPage> {
  Map<String, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/berita-bencanas/${widget.id}'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          data = jsonResponse['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Gagal fetch data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Berita')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
              ? const Center(child: Text('Data tidak ditemukan'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Image.network(data!['foto'], height: 200, fit: BoxFit.cover),
                      const SizedBox(height: 16),
                      Text('Judul: ${data!['judul']}', style: const TextStyle(fontSize: 18)),
                      Text('Lokasi: ${data!['lokasi']}'),
                      Text('Koordinat: ${data!['koordinat']}'),
                      Text('Skala Bencana: ${data!['skala']}'),
                    ],
                  ),
                ),
    );
  }
}

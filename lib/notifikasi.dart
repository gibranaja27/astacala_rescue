import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotifikasiPage extends StatefulWidget {
  final int penggunaId;

  const NotifikasiPage({super.key, required this.penggunaId});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  List notifikasi = [];

  Future<void> fetchNotifikasi() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/notifikasi/${widget.penggunaId}')
    );

    if (response.statusCode == 200) {
      setState(() {
        notifikasi = json.decode(response.body);
      });
    } else {
      throw Exception('Gagal memuat notifikasi');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifikasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: ListView.builder(
        itemCount: notifikasi.length,
        itemBuilder: (context, index) {
          final item = notifikasi[index];
          return ListTile(
            title: Text(
                'Pelaporan: ${item['informasi_singkat_bencana']}'
            ),
            subtitle: Text(
                'Status: ${item['status_verifikasi']}'
            ),
          );
        },
      ),
    );
  }
}

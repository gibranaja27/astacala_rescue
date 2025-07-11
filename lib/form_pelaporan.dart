import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FormPelaporanPage extends StatefulWidget {
  const FormPelaporanPage({Key? key}) : super(key: key);

  @override
  State<FormPelaporanPage> createState() => _FormPelaporanPageState();
}

class _FormPelaporanPageState extends State<FormPelaporanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaTeam = TextEditingController();
  final TextEditingController _jumlahPersonel = TextEditingController();
  final TextEditingController _noHp = TextEditingController();
  final TextEditingController _infoSingkat = TextEditingController();
  final TextEditingController _lokasi = TextEditingController();
  final TextEditingController _koordinat = TextEditingController();
  final TextEditingController _skala = TextEditingController();
  final TextEditingController _jumlahKorban = TextEditingController();
  final TextEditingController _deskripsi = TextEditingController();

  File? _fotoLokasi;
  File? _buktiSurat;

  final picker = ImagePicker();

  Future pickImage(bool isLokasi) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isLokasi) {
          _fotoLokasi = File(pickedFile.path);
        } else {
          _buktiSurat = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> submitForm() async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/api/pelaporans'));

    request.fields['nama_team_pelapor'] = _namaTeam.text;
    request.fields['jumlah_personel'] = _jumlahPersonel.text;
    request.fields['no_handphone'] = _noHp.text;
    request.fields['informasi_singkat_bencana'] = _infoSingkat.text;
    request.fields['lokasi_bencana'] = _lokasi.text;
    request.fields['titik_kordinat_lokasi_bencana'] = _koordinat.text;
    request.fields['skala_bencana'] = _skala.text;
    request.fields['jumlah_korban'] = _jumlahKorban.text;
    request.fields['deskripsi_terkait_data_lainya'] = _deskripsi.text;

    if (_fotoLokasi != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'foto_lokasi_bencana', _fotoLokasi!.path));
    }
    if (_buktiSurat != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'bukti_surat_perintah_tugas', _buktiSurat!.path));
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Pelaporan berhasil dikirim!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mengirim pelaporan!')));
    }
  }

  void _konfirmasiSubmit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
            'Pastikan data pelaporan yang anda berikan sudah sesuai dan valid'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              submitForm();
            },
            child: const Text('Lapor'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Pelaporan')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: _namaTeam,
                    decoration: const InputDecoration(labelText: 'Nama Tim')),
                TextFormField(
                    controller: _jumlahPersonel,
                    decoration:
                        const InputDecoration(labelText: 'Jumlah Personel')),
                TextFormField(
                    controller: _noHp,
                    decoration: const InputDecoration(labelText: 'No HP')),
                TextFormField(
                    controller: _infoSingkat,
                    decoration:
                        const InputDecoration(labelText: 'Info Singkat')),
                TextFormField(
                    controller: _lokasi,
                    decoration: const InputDecoration(labelText: 'Lokasi')),
                TextFormField(
                    controller: _koordinat,
                    decoration: const InputDecoration(labelText: 'Koordinat')),
                TextFormField(
                    controller: _skala,
                    decoration:
                        const InputDecoration(labelText: 'Skala Bencana')),
                TextFormField(
                    controller: _jumlahKorban,
                    decoration:
                        const InputDecoration(labelText: 'Jumlah Korban')),
                TextFormField(
                    controller: _deskripsi,
                    decoration: const InputDecoration(labelText: 'Deskripsi')),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => pickImage(true),
                  child: const Text('Pilih Foto Lokasi'),
                ),
                ElevatedButton(
                  onPressed: () => pickImage(false),
                  child: const Text('Pilih Bukti Surat Tugas'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _konfirmasiSubmit,
                  child: const Text('LAPOR'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

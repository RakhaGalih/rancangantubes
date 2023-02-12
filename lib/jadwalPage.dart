import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final controllerMatkul = TextEditingController();
  final controllerTugas = TextEditingController();
  final controllerDeadline = TextEditingController();

  Future createJadwal({required Jadwal jadwal}) async {
    final docJadwal = FirebaseFirestore.instance.collection('jadwal').doc();
    jadwal.id = docJadwal.id;

    final json = jadwal.toJson();
    await docJadwal.set(json);
  }
  InputDecoration decoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add User')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: controllerMatkul,
            decoration: decoration('Mata Kuliah'),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: controllerTugas,
            decoration: decoration('Tugas'),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: controllerDeadline,
            decoration: decoration('Deadline'),
          ),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
              onPressed: () {
                final jadwal = Jadwal(
                  matkul: controllerMatkul.text,
                  tugas: controllerTugas.text,
                  deadline: DateFormat('dd/MM/yyyy').parse(controllerDeadline.text),
                );

                createJadwal(jadwal: jadwal);
                Navigator.pop(context);
              },
              child: const Text("Tambah"))
        ],
      ),
    );
  }
}

class Jadwal {
  late String id, matkul, tugas;
  late DateTime deadline;
  Jadwal(
      {this.id = '',
      required this.matkul,
      required this.tugas,
      required this.deadline});

  Map<String, dynamic> toJson() => {
        'id': id,
        'matkul': matkul,
        'tugas': tugas,
        'deadline': deadline,
      };
}

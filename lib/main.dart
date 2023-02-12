import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'jadwalPage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();
  //stream untuk membaca jadwal
  Stream<List<Jadwal>> readJadwal() => FirebaseFirestore.instance
      .collection('jadwal') //mengambil collection 'jadwal'
      .snapshots() //mengambil dokumen dalam collection dalam bentuk json
      .map((snapshot) =>
          snapshot.docs.map((doc) => Jadwal.fromJson(doc.data())).toList());

  //
  Widget buildJadwal(Jadwal jadwal) => ListTile(
        leading: CircleAvatar(child: Text(jadwal.matkul)),
        title: Text(jadwal.tugas),
        subtitle: Text(jadwal.deadline.toIso8601String()),
        trailing: GestureDetector(
            onTap: () {
              //mengambil instance dari dokumen dengan id spesifik
              final docJadwal = FirebaseFirestore.instance
                  .collection('jadwal')
                  .doc(jadwal.id);
              //menghapus doc
              docJadwal.delete();
            },
            child: const Icon(Icons.check)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Tugas :)'),
      ),
      body: StreamBuilder(
          stream: readJadwal(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final jadwal = snapshot.data!;
              return ListView(
                children: jadwal.map(buildJadwal).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JadwalPage()),
          );
        },
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

  //mengubah Json Jadwal ke dalam bentuk kelas
  static Jadwal fromJson(Map<String, dynamic> json) => Jadwal(
      id: json['id'],
      matkul: json['matkul'],
      tugas: json['tugas'],
      deadline: (json['deadline'] as Timestamp).toDate());
}

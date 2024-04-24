import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // Import paket intl untuk formatting tanggal

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String _parkingStatus1 = 'Kosong';
  String _parkingStatus2 = 'Kosong';
  String _parkingStatus3 = 'Kosong';
  String _timeDifferenceP1 = '';
  String _timeDifferenceP2 = '';
  String _timeDifferenceP3 = '';
  bool _isSystemActive = true;

  @override
  void initState() {
    super.initState();
    // Mendengarkan perubahan pada Firebase Realtime Database
    _database.reference().child('aktif').onValue.listen((event) {
      final value = event.snapshot.value as bool?;
      setState(() {
        _isSystemActive = value ?? true;
      });
    });

    _database.reference().child('parkir1').onValue.listen((event) {
      final value = event.snapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        setState(() {
          _parkingStatus1 = value['kosong'] ?? true ? 'Kosong' : 'Sudah Terisi';
          _timeDifferenceP1 = calculateTimeDifference(value['waktu']);
        });
      }
    });

    _database.reference().child('parkir2').onValue.listen((event) {
      final value = event.snapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        setState(() {
          _parkingStatus2 = value['kosong'] ?? true ? 'Kosong' : 'Sudah Terisi';
          _timeDifferenceP2 = calculateTimeDifference(value['waktu']);
        });
      }
    });

    _database.reference().child('parkir3').onValue.listen((event) {
      final value = event.snapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        setState(() {
          _parkingStatus3 = value['kosong'] ?? true ? 'Kosong' : 'Sudah Terisi';
          _timeDifferenceP3 = calculateTimeDifference(value['waktu']);
        });
      }
    });
  }

  // Fungsi untuk menghitung selisih waktu
  String calculateTimeDifference(String parkirWaktu) {
    DateFormat formatter = DateFormat("dd/MM/yyyy HH:mm");
    DateTime parkirDateTime = formatter.parse(parkirWaktu);
    DateTime now = DateTime.now();
    Duration difference = now.difference(parkirDateTime);

    print('Difference: $difference');

    if (difference.inDays > 365) {
      print('Days: ${difference.inDays}');
      return '${(difference.inDays / 365).floor()} tahun yang lalu';
    } else if (difference.inDays >= 30) {
      print('Days: ${difference.inDays}');
      return '${(difference.inDays / 30).floor()} bulan yang lalu';
    } else if (difference.inDays >= 7) {
      print('Days: ${difference.inDays}');
      return '${(difference.inDays / 7).floor()} minggu yang lalu';
    } else if (difference.inDays > 0) {
      print('Days: ${difference.inDays}');
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      print('Hours: ${difference.inHours}');
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      print('Minutes: ${difference.inMinutes}');
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inSeconds > 0) {
      print('Seconds: ${difference.inSeconds}');
      return '${difference.inSeconds} detik yang lalu';
    } else {
      print('Just now');
      return 'Baru saja';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistem Manajemen Parkir',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 42, 61, 129),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                child: Text('Denah Tempat Parkir',
                    style: TextStyle(color: Colors.white)),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * (102 / 297),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/tparkir.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                  width: 220,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 42, 61, 129),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Ketersediaan Tempat Parkir',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _isSystemActive
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    0.4, // Misalnya, 40% dari lebar layar
                                child: Card(
                                  color: _parkingStatus1 == 'Kosong'
                                      ? Color.fromRGBO(255, 185, 185, 1)
                                      : Color.fromRGBO(199, 255, 185, 1),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 4, 16, 4),
                                        child: Text(
                                          'Parkir 1',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.directions_car_outlined,
                                              size: 150),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 4, 16, 0),
                                            child: Text(
                                              _parkingStatus1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 0, 16, 0),
                                            child: Text(
                                              _timeDifferenceP1,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Card(
                                color: _parkingStatus2 == 'Kosong'
                                    ? Color.fromRGBO(255, 185, 185, 1)
                                    : Color.fromRGBO(199, 255, 185, 1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 4, 16, 4),
                                      child: Text('Parkir 2',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.directions_car_outlined,
                                            size: 150),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 4, 16, 0),
                                          child: Text(_parkingStatus2,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 0, 16, 0),
                                          child: Text(_timeDifferenceP2,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Card(
                                    color: _parkingStatus3 == 'Kosong'
                                        ? Color.fromRGBO(255, 185, 185, 1)
                                        : Color.fromRGBO(199, 255, 185, 1),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 4, 16, 4),
                                          child: Text('Parkir 3',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.directions_car_outlined,
                                                size: 150),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 4, 16, 0),
                                              child: Text(_parkingStatus3,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 0, 16, 0),
                                              child: Text(_timeDifferenceP3,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: Column(children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text('Perangkat Tidak Aktif')
                      ]),
                    ), // Empty widget when system is inactive
            ],
          ),
        ),
      ),
    );
  }
}

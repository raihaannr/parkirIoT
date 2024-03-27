import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistem Manajemen Parkir',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 42, 61, 129),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            child: Text('Denah Tempat Parkir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

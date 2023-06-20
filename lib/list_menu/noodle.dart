import 'package:flutter/material.dart';

class Noodle extends StatefulWidget {
  const Noodle({Key? key}) : super(key: key);

  @override
  State<Noodle> createState() => _NoodleState();
}

class _NoodleState extends State<Noodle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Text("Menu List jus")
            ],
          )
        ],
      ),
    );
  }
}

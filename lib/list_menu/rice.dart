import 'package:flutter/material.dart';

class Rice extends StatefulWidget {
  const Rice({Key? key}) : super(key: key);

  @override
  State<Rice> createState() => _RiceState();
}

class _RiceState extends State<Rice> {
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

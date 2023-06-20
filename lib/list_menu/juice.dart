import 'package:flutter/material.dart';

class Juice extends StatefulWidget {
  const Juice({Key? key}) : super(key: key);

  @override
  State<Juice> createState() => _JuiceState();
}

class _JuiceState extends State<Juice> {
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

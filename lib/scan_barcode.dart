import 'package:flutter/material.dart';

class ScanBarcode extends StatefulWidget {
  const ScanBarcode({Key? key}) : super(key: key);

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset("assets/images/logo.jpg"),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 15, left: 10, right: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 41, 185, 58),
                    borderRadius: BorderRadius.circular(5)),
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/qrview");
                  },
                  child: Center(
                    child: Text(
                      "Order",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

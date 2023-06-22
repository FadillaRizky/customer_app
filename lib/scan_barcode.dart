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
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: (){
                  Navigator.pushNamed(context, "/menu");
                }, 
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Color.fromARGB(255, 41, 185, 58),
                  child: Center(
                    child: Text(
                      "Scan Meja",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                  )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

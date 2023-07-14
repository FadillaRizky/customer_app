import 'package:customer_app/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ScanBarcode extends StatefulWidget {

  const ScanBarcode({
    Key? key

  }) : super(key: key);

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  cekScan()async{
    
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool status = pref.containsKey("noMeja");
    if (status == true) {
      Navigator.pushReplacementNamed(context, "/menu");
    }
  }

  @override
  void initState() {
    super.initState();
    cekScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.jpg",
                height: 400,
                width: 400,
              ),
              SizedBox(
                height: 20,
              ),
              kIsWeb == true ? 
              Container(
                margin:
                    EdgeInsets.only(top: 5, bottom: 15, left: 10, right: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("Tolong Scan Barcodenya terlebih dahulu menggunakan scanner",style: TextStyle(color:Colors.black,fontSize: 26),),
              )
              : Container(
                margin:
                    EdgeInsets.only(top: 5, bottom: 15, left: 10, right: 10),
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
                          color: Colors.white),
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

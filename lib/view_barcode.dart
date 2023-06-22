import 'dart:developer';
import 'dart:io';

import 'package:customer_app/shared_pref.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QrView extends StatefulWidget {
  const QrView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  Barcode? result;
  String? meja;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  submitBarcode(){
    if (result!.code != null) {
      LoginPref.saveToSharedPref(meja!);
      Navigator.pop(context);
      Navigator.pushNamed(context, "/menu");

    }

  }
  noMeja()async{
    print(result!.code!);
    DataSnapshot snapshot = await FirebaseDatabase.instance.ref().child("meja").child(result!.code!).get();
    var data = snapshot.value as Map;
    setState(() {
      if(result!.code! != snapshot.key){
        meja = data['no_meja'];
      }
      meja = "gk ada";
    });
  }
  

  @override
  void initState() {
    super.initState();
    
  }

  Widget isStringInRange(String value,double width) {
    print(result!.code!);
    int? parsedValue = int.tryParse(value);
    if (parsedValue != null && parsedValue >= 1 && parsedValue <= 1000) {
        return Column(
          children: [
            Text(
              'Nomer Meja : ${value}',
              style: TextStyle(
                  fontSize: 20, overflow: TextOverflow.ellipsis),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width/3,
                  child: ElevatedButton(
                    onPressed: () {
                      submitBarcode();
                    },
                    child: Text("Pesan Sekarang"),
                  ),
                ),
              ],
            )
          ],
        );
    } else {
      return Text("Maaf Barcode yang anda masukan salah");
    }
  }

  // In order to get hot reload to work we need to pause the camera ifthe platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    if (result != null) {
      noMeja();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () async {
                await controller?.toggleFlash();
              },
              icon: Icon(Icons.flash_on_outlined)
            // FutureBuilder(
            //   future: controller?.getFlashStatus(),
            //   builder: (context, snapshot) {
            //     if (snapshot.data == true || snapshot.data == "true")
            //       return Icon(Icons.flash_on_outlined);
            //     if (snapshot.data == false || snapshot.data == "false") {
            //       return Icon(Icons.flash_off);
            //     }
            //     return Text("");
            //   },
            // ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Container(
            width: width,
            height: height / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                meja == "gk ada" ? 
                Text(
                  'QR tidak valid',
                  style: TextStyle(fontSize: 20),
                ) : Container(), 
                if (result != null && meja != "gk ada")
                  Text(
                    // 'Barcode Type: ${describeEnum(result!.format)}  '
                    'Nomer Meja : ${meja}',
                    style: TextStyle(
                        fontSize: 20, overflow: TextOverflow.ellipsis),
                  )
                else
                  const Text(
                    'Scan Barcode Meja',
                    style: TextStyle(fontSize: 20),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 5,
          borderLength: 30,
          borderWidth: 5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class CustomInputFormatter extends TextInputFormatter {
  final String sample, separator;

  CustomInputFormatter({
    required this.sample,
    required this.separator,
  }) {
    assert(sample != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > sample.length) return oldValue;
        if (newValue.text.length < sample.length &&
            sample[newValue.text.length - 1] == separator) {
          return TextEditingValue(
              text:
              '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
              selection: TextSelection.collapsed(
                offset: newValue.selection.end + 1,
              ));
        }
      }
    }
    return newValue;
  }
}

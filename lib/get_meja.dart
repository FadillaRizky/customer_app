import 'package:customer_app/menu.dart';
import 'package:customer_app/shared_pref.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMeja {
  static Future QrMeja(String uid,BuildContext context) async{
    DataSnapshot snapshot = await FirebaseDatabase.instance.ref().child('meja').get();

    if (uid == null || uid == "" || uid == "null" || !snapshot.hasChild(uid)) {
      EasyLoading.showError("QR Meja tidak terdeteksi/salah silahkan coba kembali");
      Navigator.pop(context);
      return;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    bool status = pref.containsKey("noMeja");
    if(status){
      pref.remove("noMeja");
    }

    FirebaseDatabase.instance.ref().child('meja').child(uid).onValue.listen((event) {
      Map<dynamic,dynamic> data = event.snapshot.value as Map<dynamic,dynamic>;
      
      LoginPref.saveToSharedPref(data['no_meja']);
    });

  }
}
class WidgetMeja extends StatefulWidget {
  const WidgetMeja({super.key, this.uid = ""});
  final String uid;
  @override
  State<WidgetMeja> createState() => _WidgetMejaState();
}

class _WidgetMejaState extends State<WidgetMeja> {

  @override
  void initState() {
    super.initState();
    GetMeja.QrMeja(widget.uid, context);
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    if(widget.uid == null || widget.uid == "" || widget.uid == "null"){
      return Center(
        child: Text("QR Meja tidak terdeteksi/salah silahkan coba kembali"),
      );
    }else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
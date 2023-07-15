import 'package:customer_app/database/database_instance.dart';
import 'package:customer_app/model/product_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Firebase {
  static void order(Map<String, dynamic> data, Box box) async {
    DatabaseInstance? db = DatabaseInstance();
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('orderan');
    SharedPreferences pref = await SharedPreferences.getInstance();

    final key = dbRef.push().key;
    int subTotal = 0;

    dbRef.child(key!).set({
      "create_at": DateFormat('yyyy-MM-dd HH:mm:ss')
          .parse(DateTime.now().toString())
          .toString(),
      "name_customer": data['name_customer'],
      "no_meja": data['no_meja'],
      "catatan": data['catatan'],
      "status": "pending",
    });

    for (var x = 0; x < box.length; x++) {
      Map<dynamic, dynamic> data = box.getAt(x);
      dbRef.child(key!).child("list_order").child("${box.keyAt(x)}").update({
        "nama": data['name_product'],
        "qty": int.parse(data['qty'].toString()),
        "satuan": int.parse(data['price'].toString()),
        "total_harga": int.parse(data['total_price'].toString()),
      });
      subTotal += int.parse(data['total_price'].toString());
      box.deleteAt(x);
    }
    dbRef.child(key!).update({"total_harga": subTotal});
    pref.clear();
  }
}

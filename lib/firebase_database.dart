import 'package:customer_app/database_instance.dart';
import 'package:customer_app/model/product_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Firebase {

  static void order(Map<String,dynamic> data)async{
    DatabaseInstance? db = DatabaseInstance();
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('orderan');
    DatabaseReference meja = FirebaseDatabase.instance.ref().child("meja").child(data['meja_uid'].toString());
    DataSnapshot snapshot = await meja.get();

    Map mapMeja = snapshot.value as Map;
    
    await db!.database();
    db.all().then((List<ProductModel> value){
      final key = dbRef.push().key;
      int subTotal = 0;

      meja.set({
        "status":"penuh"
      });

      dbRef.child(key!).set({
        "create_at": DateFormat('dd-MM-yyyy HH:mm:ss').parse(DateTime.now().toString()),
        "name_customer": data['name_customer'],
        "no_meja": mapMeja['no_meja'],
        "catatan": data['catatan'],
        "status":"pending",
      });

      for (var x in value) {
        dbRef.child(key!).child("list_order").child("${x.id}").set({
          "nama":x.nameProduct,
          "qty":x.qty,
          "satuan":x.price,
          "total_harga":x.totalPrice,
        });
        subTotal += int.parse(x.totalPrice.toString());
      }
      dbRef.child(key!).set({
        "total_harga": subTotal
      });
    });
  }
}
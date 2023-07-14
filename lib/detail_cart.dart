import 'package:customer_app/database/firebase_database.dart';
import 'package:customer_app/list_menu.dart';
import 'package:customer_app/shared_pref.dart';
import 'package:customer_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';

import 'database/database_instance.dart';
import 'model/product_model.dart';

class DetailCart extends StatefulWidget {
  const DetailCart({Key? key}) : super(key: key);

  @override
  State<DetailCart> createState() => _DetailCartState();
}

class _DetailCartState extends State<DetailCart> {
  TextEditingController noteController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController noMejaController = TextEditingController();
  final intlFormat = intl.NumberFormat("#,##0");
  DatabaseInstance? databaseInstance;
  String? noMeja;
  int totalHarga = 0;
  int totalItem = 0;

  submitCart() {
    if (noMeja!.isEmpty) {
      EasyLoading.showError(
          "Maaf meja anda tidak terdeteksi. Silahkan di scan kembali QR meja-nya",
          dismissOnTap: true);
      return;
    }
    var box = Hive.box('cart');
    if (box.length <= 0) {
      EasyLoading.showError("Orderan tidak boleh kosong", dismissOnTap: true);
      return;
    }
    if (namaController.text.isEmpty) {
      EasyLoading.showError("Nama Customer Belum Terisi");
      return;
    }
    if (namaController.text == "") {
      EasyLoading.showInfo("Nama Pelanggan Kosong", dismissOnTap: true);
      return;
    }
    if (noteController.text == "") {
      EasyLoading.showInfo("Catatan Kosong", dismissOnTap: true);
      return;
    }
    Firebase.order({
      'no_meja': noMejaController.text,
      'name_customer': namaController.text,
      'catatan': noteController.text,
    }, box);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MenuList()));
  }

  initnoMeja() async {
    await LoginPref.getPref().then((value) {
      setState(() {
        noMeja = value.noMeja!;
      });
    });
  }

  Future hiveDatabase() async {
    var box = Hive.box('cart');
    var harga = 0;

    for (var x in box.values) {
      Map<dynamic, dynamic> data = x;
      harga += int.parse(data['total_price'].toString());
    }
    setState(() {
      totalItem = box.length;
      totalHarga = harga;
    });
  }

  cekScan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool status = pref.containsKey("noMeja");
    if (status == false) {
      Navigator.pushReplacementNamed(context, "/");
      EasyLoading.showError("Kamu belum scan Qr Code silahkan scan kembali",
          dismissOnTap: true);
      return;
    }
    LoginPref.getPref().then((value) {
      noMejaController.text = value.noMeja!;
    });
  }

  @override
  void initState() {
    super.initState();
    databaseInstance = DatabaseInstance();
    hiveDatabase();
    initnoMeja();
    cekScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pesanan Saya"),
          backgroundColor: Color(0xFF399D44),
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: showListCart(Hive.box('cart'), context),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "  Nomor Meja",
              style: Constants.subtitle,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              child: TextFormField(
                minLines: 1,
                controller: noMejaController,
                enabled: false,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            Text(
              "  Nama Customer",
              style: Constants.subtitle,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              child: TextField(
                minLines: 1,
                controller: namaController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            Text(
              "  Catatan",
              style: Constants.subtitle,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              child: TextField(
                minLines: 1,
                maxLines: 5,
                controller: noteController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 15, left: 10, right: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 41, 185, 58),
                  borderRadius: BorderRadius.circular(5)),
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  submitCart();
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
        ));
  }

  Widget showListCart(Box box, BuildContext context) {
    Future delete(String id) async {
      box.delete(id);
      hiveDatabase();
    }

    if (box.length <= 0) {
      return Center(
        child: Container(
          child: Text("Pesanan ada kosong"),
        ),
      );
    }

    return ListView.builder(
      itemCount: box.length,
      itemBuilder: (context, index) {
        String key = box.keyAt(index);
        Map<dynamic, dynamic> value = box.getAt(index);

        return Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        child: Text(
                          "${index + 1}.",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${toBeginningOfSentenceCase(value['name_product'])}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Rp.${intlFormat.format(int.parse(value['price'].toString()))}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     IconButton(
                  //         onPressed: () {
                  //           if (amount[index] >
                  //               1) {
                  //             setState(
                  //                 () {
                  //               amount[index]--;
                  //             });
                  //           }
                  //         },
                  //         icon: Icon(Icons
                  //             .remove)),
                  //     Text("${amount[index]}"),
                  //     IconButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             amount.update(index, (value) => amount[index]++);
                  //             // totalamountPrice =
                  //             //     int.parse(snapshot.data![index].price.toString()) *
                  //             //         amount[index];
                  //           });
                  //         },
                  //         icon: Icon(
                  //             Icons.add)),
                  //   ],
                  // ),

                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("QTY : ${value['qty']}"),
                          Text(
                              "Total : Rp${intlFormat.format(int.parse(value['total_price'].toString()))}"),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          delete(key);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider()
          ],
        );
      },
    );
  }
}

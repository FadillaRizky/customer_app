import 'dart:async';

import 'package:customer_app/utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/currency.dart';
import '../database/database_instance.dart';
import '../model/product_model.dart';

class Coffee extends StatefulWidget {
  const Coffee({Key? key}) : super(key: key);

  @override
  State<Coffee> createState() => _CoffeeState();
}

class _CoffeeState extends State<Coffee> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  final intlFormat = intl.NumberFormat("#,##0");
  int totalHarga = 0;
  int totalItem = 0;

  void addCart(uid, nama, harga, amount, totalamountPrice) async {
    var box = Hive.box('cart');

    box.put(uid, {
      "name_product": nama,
      "price": harga,
      "qty": amount,
      "total_price": totalamountPrice
    });
    hiveDatabase();
    Navigator.of(context).pop();
    setState(() {});
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
  cekScan()async{
    
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool status = pref.containsKey("noMeja");
    if (status == false) {
      Navigator.pushReplacementNamed(context, "/");
      EasyLoading.showError("Kamu belum scan Qr Code silahkan scan kembali",dismissOnTap: true);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    hiveDatabase();
    cekScan();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final heigth = mediaQuery.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Coffee"),
        backgroundColor: Color(0xFF399D44),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FirebaseDatabaseQueryBuilder(
          pageSize: 100000,
          query: FirebaseDatabase.instance.ref().child("menu"),
          builder: (context, snapshot, child) {
            if (snapshot.hasData) {
              var data = snapshot.docs.where((data) {
                var val = data.value as Map;
                return val['kategori'] == "coffee";
              }).toList();
              if (data.length <= 0) {
                return Center(
                  child: Text("Menu untuk kategori ini kosong"),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var val = data[index].value as Map;
                  val['key'] = data[index].key;
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Card(
                                  clipBehavior: Clip.hardEdge,
                                  child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image.network(
                                        "${val['image']}",
                                        fit: BoxFit.cover,
                                        // loadingBuilder: (BuildContext, Widget, ImageChunkEvent){
                                        //   return CircularProgressIndicator();
                                        // },
                                        errorBuilder: (BuildContext, Object, StackTrace){
                                          return  Text('Gambar Kosong');
                                        },
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${toBeginningOfSentenceCase(val['name'])}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Rp.${intlFormat.format(val['harga'])}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${toBeginningOfSentenceCase(val['deskripsi'])}",
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green),
                                    ),
                                    onPressed: () {
                                      // print("masuk");
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          int amount = 1;
                                          int totalamountPrice = val['harga'];
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(20.0),
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${toBeginningOfSentenceCase(val['name'])}",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: Icon(
                                                                Icons.clear)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        "${toBeginningOfSentenceCase(val['deskripsi'])}"),
                                                    Divider(),
                                                    Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  if (amount >
                                                                      1) {
                                                                    setState(
                                                                        () {
                                                                      amount--;
                                                                    });
                                                                  }
                                                                },
                                                                icon: Icon(Icons
                                                                    .remove)),
                                                            Text("$amount"),
                                                            IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    amount++;
                                                                    totalamountPrice =
                                                                        val['harga'] *
                                                                            amount;
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                    Icons.add)),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .green),
                                                              ),
                                                              onPressed: () {
                                                                addCart(
                                                                    val['key'],
                                                                    val['name'],
                                                                    val['harga'],
                                                                    amount,
                                                                    totalamountPrice);
                                                              },
                                                              child: Text(
                                                                  "Add Rp.${intlFormat.format(amount * val['harga'])} ")),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ).then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: Text("Add to Cart +")),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: totalItem! <= 0
          ? Container()
          : FittedBox(
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            Colors.green, 
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${totalItem} ITEM(S)",
                                style: Constants.subtitle,
                              ),
                              Text(
                                Currency.rupiah.format(totalHarga),
                                style: Constants.subtitle,
                              )
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/detailcart");
                              },
                              child: Text("Lihat Pesanan"))
                        ],
                      ),
                    )),
              ),
            ),
    );
  }
}

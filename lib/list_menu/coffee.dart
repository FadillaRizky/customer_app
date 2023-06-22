import 'package:customer_app/utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;


import '../utils/currency.dart';
import '../database_instance.dart';
import '../model/product_model.dart';

class Coffee extends StatefulWidget {
  const Coffee({Key? key}) : super(key: key);

  @override
  State<Coffee> createState() => _CoffeeState();
}

class _CoffeeState extends State<Coffee> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  final intlFormat = intl.NumberFormat("#,##0");
  int? totalHarga;

  void addCart(nama,harga, amount, totalamountPrice) async {
    await databaseInstance.insert({
      "name_product": nama,
      "price": harga,
      "qty": amount,
      "total_price": totalamountPrice
    });
    Navigator.of(context).pop();
    setState(() {});
  }

  Future getTotal() async {
    var totalprice;
    var dbClient = await databaseInstance!.database();
    var result = await dbClient.rawQuery(
        "SELECT SUM (${databaseInstance!.totalPrice}) FROM ${databaseInstance!.table}");
    result[0].forEach((key, value) {
      totalprice = value;
    });
    if (totalprice == null) {
      return 0;
    }
    return totalprice;
  }

  Stream<int> countStream() async* {
    int total = await getTotal();
    yield total;
  }

  Future initDatabase() async {
    await databaseInstance!.database();
    setState(() {});
  }

  List coffeeName = [
    "Americano",
    "Espreso",
    "Cappuccino",
  ];
  List coffeePrice = [
    50000,
    25000,
    40000,
  ];

  @override
  void initState() {
    super.initState();
    databaseInstance = DatabaseInstance();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final heigth = mediaQuery.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Coffee"),
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
              if(data.length <= 0){
                return Center(
                  child: Text("Menu untuk kategori ini kosong"),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var val = data[index].value as Map;
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
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${toBeginningOfSentenceCase(val['name'])}",
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.w700),
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
                                                    Text("${toBeginningOfSentenceCase(val['deskripsi'])}"),
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
      floatingActionButton: databaseInstance != null
          ? FutureBuilder<List<ProductModel>>(
              future: databaseInstance!.all(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length == 0) {
                    return Center(
                      child: Text("Produk Belum Ditambahkan"),
                    );
                  }
                  return FittedBox(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Container(
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors
                                  .green, // Set the desired border color here
                              width: 1, // Set the desired border width here
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
                                      "${snapshot.data!.length} ITEM(S)",
                                      style: Constants.subtitle,
                                    ),
                                    StreamBuilder(
                                        stream: countStream(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text(
                                              "0",
                                              style: TextStyle(fontSize: 20),
                                            );
                                          } else {
                                            totalHarga = snapshot.data;
                                            return Text(
                                              Currency.rupiah
                                                  .format(snapshot.data),
                                              style: Constants.subtitle,
                                            );
                                          }
                                        })
                                  ],
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/detailcart");
                                    },
                                    child: Text("Lihat Pesanan"))
                              ],
                            ),
                          )),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  Center(child: Text("${snapshot.error}"));
                }
                return Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              Colors.green, // Set the desired border color here
                          width: 1, // Set the desired border width here
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("0 ITEM"),
                          ],
                        ),
                      )),
                );
              },
            )
          : SizedBox(),
    );
  }
}

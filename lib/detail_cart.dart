import 'package:customer_app/firebase_database.dart';
import 'package:customer_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:intl/intl.dart' as intl;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'database_instance.dart';
import 'model/product_model.dart';

class DetailCart extends StatefulWidget {
  const DetailCart({Key? key}) : super(key: key);

  @override
  State<DetailCart> createState() => _DetailCartState();
}

class _DetailCartState extends State<DetailCart> {
  TextEditingController namaController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final intlFormat = intl.NumberFormat("#,##0");
  bool load = false;
  DatabaseInstance? databaseInstance;

  Future initDatabase() async {
    await databaseInstance!.database();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    databaseInstance = DatabaseInstance();
    initDatabase();
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
              child: FutureBuilder<List<ProductModel>>(
                future: databaseInstance!.all(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length == 0) {
                      return Container();
                      // return Center(
                      //   child: Text("Produk Belum Ditambahkan"),
                      // );
                    }
                    return showListCart(snapshot, context);
                  }
                  if (snapshot.hasError) {
                    Center(child: Text("${snapshot.error}"));
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
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
                  if (load == false) {
                    if (namaController.text != null) {
                      Firebase.order({
                        'no_meja' : 1,
                        'name_customer': namaController.text,
                        'catatan': noteController.text,
                      });
                      setState(() {
                        load = true;
                        EasyLoading.show(status: 'loading...',dismissOnTap: true);
                      });
                      Navigator.of(context).pushReplacementNamed('/');
                      return;
                    }
                    EasyLoading.showError('Please insert your name',dismissOnTap: true);
                  }
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
        ));
  }

  Widget showListCart(
      AsyncSnapshot<List<ProductModel>> snapshot, BuildContext context) {
    Future delete(String id) async {
      await databaseInstance!.delete(id);
      setState(() {});
    }

    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
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
                          "${index + 1}. ",
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
                            "${toBeginningOfSentenceCase(snapshot.data![index].nameProduct!)}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Rp.${intlFormat.format(int.parse(snapshot.data![index].price!))}",
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
                          Text("QTY : ${snapshot.data![index].qty}"),
                          Text(
                              "Total : Rp${intlFormat.format(int.parse(snapshot.data![index].totalPrice.toString()))}"),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          delete(snapshot.data![index].id!);
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

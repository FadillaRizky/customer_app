import 'package:flutter/material.dart';

import '../database_instance.dart';
import '../model/product_model.dart';
import '../utils/constants.dart';
import '../utils/currency.dart';

class Juice extends StatefulWidget {
  const Juice({Key? key}) : super(key: key);

  @override
  State<Juice> createState() => _JuiceState();
}

class _JuiceState extends State<Juice> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  int? totalHarga;

  Future initDatabase() async {
    await databaseInstance!.database();
    setState(() {});
  }
  void addCart(index, amount, totalamountPrice) async {
    await databaseInstance.insert({
      "name_product": coffeeName[index],
      "price": coffeePrice[index],
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
  List coffeeName = [
    "Jus Jeruk",
    "Jus Melon",
    "Jus Mangga",
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
      appBar: AppBar(title: Text("Juice"),),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
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
                            Text(
                              "${index + 1}. ${coffeeName[index]}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Card(
                                  clipBehavior: Clip.hardEdge,
                                  child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image.asset(
                                        "assets/images/juice.jpg",
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Rp.${coffeePrice[index]}",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w500),
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
                                          borderRadius: BorderRadius.circular(8),
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
                                          int totalamountPrice = coffeePrice[index];
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20.0),
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${coffeeName[index]}",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            icon: Icon(Icons.clear)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        "Americano adalah minuman kopi yang sempurna untuk penggemar kopi yang menginginkan rasa yang kuat namun tetap segar.Americano menawarkan kombinasi yang sempurna antara kekayaan kopi dan kelegitan yang menyegarkan."),
                                                    Divider(),
                                                    Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  if (amount > 1) {
                                                                    setState(() {
                                                                      amount--;
                                                                    });
                                                                  }
                                                                },
                                                                icon: Icon(
                                                                    Icons.remove)),
                                                            Text("$amount"),
                                                            IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    amount++;
                                                                    totalamountPrice =
                                                                        coffeePrice[
                                                                        index] *
                                                                            amount;
                                                                  });
                                                                },
                                                                icon:
                                                                Icon(Icons.add)),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                    RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        8),
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                    Colors
                                                                        .green),
                                                              ),
                                                              onPressed: () {
                                                                addCart(index, amount,
                                                                    totalamountPrice);
                                                              },
                                                              child: Text(
                                                                  "Add ${amount * coffeePrice[index]} ")),
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
              ),
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
      floatingActionButton:
      databaseInstance != null
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
                        color: Colors.green, // Set the desired border color here
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
                              Text("${snapshot.data!.length} ITEM(S)",style: Constants.subtitle,),
                              StreamBuilder(
                                  stream: countStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text(
                                        "0",
                                        style: TextStyle(fontSize: 20),
                                      );
                                    } else {
                                      totalHarga = snapshot.data;
                                      return Text(
                                        Currency.rupiah.format(snapshot.data),
                                        style: Constants.subtitle,
                                      );
                                    }
                                  })

                            ],
                          ),
                          TextButton(onPressed: (){
                            Navigator.pushNamed(context, "/detailcart");
                          }, child: Text("Lihat Pesanan"))
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
                    color: Colors.green, // Set the desired border color here
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

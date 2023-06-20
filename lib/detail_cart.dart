import 'package:customer_app/firebase_database.dart';
import 'package:customer_app/utils/constants.dart';
import 'package:flutter/material.dart';

import 'database_instance.dart';
import 'model/product_model.dart';

class DetailCart extends StatefulWidget {
  const DetailCart({Key? key}) : super(key: key);

  @override
  State<DetailCart> createState() => _DetailCartState();
}

class _DetailCartState extends State<DetailCart> {
  TextEditingController noteController = TextEditingController();
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
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: databaseInstance!.all(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length == 0) {
                      return Center(
                        child: Text("Produk Belum Ditambahkan"),
                      );
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
              "Catatan",
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
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
          ],
        ));
  }

  Widget showListCart(
      AsyncSnapshot<List<ProductModel>> snapshot, BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return Container(
          height: 50,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(snapshot.data![index].nameProduct!),
              Container(

                child: Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
                    Text(snapshot.data![index].qty!),
                    IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                  ],
                ),
              ),
            ],
          ),

        );
      },
    );
  }
}

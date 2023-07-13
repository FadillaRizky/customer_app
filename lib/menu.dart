
import 'dart:async';

import 'package:customer_app/model/product_model.dart';
import 'package:flutter/material.dart';

import 'list_menu/coffee.dart';
import 'database/database_instance.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key,}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}
enum DrawerSelection { Home, Profile, Settings }

class _MenuState extends State<Menu> {
  DatabaseInstance? databaseInstance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DrawerSelection _currentSelection = DrawerSelection.Home;

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onDrawerItemSelected(DrawerSelection selection) {
    setState(() {
      _currentSelection = selection;
    });

    Navigator.pop(context); // Close the drawer
  }

  Widget _buildBody() {
    switch (_currentSelection) {
      case DrawerSelection.Profile:
        return Coffee();
      default:
        return Coffee();
    }
  }
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
      key: _scaffoldKey,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black,),
            onPressed: _openDrawer
        ),
      ),
      body: _buildBody(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: FutureBuilder<List<ProductModel>>(
            future: databaseInstance!.all(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length == 0) {
                  return SizedBox();
                }
                return GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
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
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Pesanan Saya"),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.clear))
                                  ],)
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ).then((value) {
                      if (value != null) {}
                    });
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
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
                      child: Text("${snapshot.data!.length}ITEM(S)"),
                    ),
                  ),
                ) ;
              }
              if (snapshot.hasError) {
                Center(child: Text("${snapshot.error}"));
              }
              return SizedBox(

              );
            }


        ),
      ),

      drawer: Drawer(
      width: 200,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Drinks",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () => _onDrawerItemSelected(DrawerSelection.Profile),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10))),
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 75,
                            width: double.infinity,
                            child: Image.asset("assets/images/coffee.jpg",
                                fit: BoxFit.fitWidth)),
                        Positioned.fill(
                            child: Center(child: Text("Coffee",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30),)))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                GestureDetector(
                  onTap: () => _onDrawerItemSelected(DrawerSelection.Settings),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10))),
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 75,
                            width: double.infinity,
                            child: Image.asset("assets/images/mojito.jpg",
                                fit: BoxFit.fitWidth)),
                        Positioned.fill(
                            child: Center(child: Text("Non Coffee",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30),)))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10))),
                  child: Stack(
                    children: [
                      SizedBox(
                          height: 75,
                          width: double.infinity,
                          child: Image.asset(
                              "assets/images/juice.jpg", fit: BoxFit.fitWidth)),
                      Positioned.fill(
                          child: Center(child: Text("Juice", style: TextStyle(
                              color: Colors.white, fontSize: 30),)))
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text("Food",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10))),
                  child: Stack(
                    children: [
                      SizedBox(
                          height: 75,
                          width: double.infinity,
                          child: Image.asset("assets/images/nasigoreng.jpg",
                              fit: BoxFit.fitWidth)),
                      Positioned.fill(
                          child: Center(child: Text("Rice", style: TextStyle(
                              color: Colors.white, fontSize: 30),)))
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10))),
                  child: Stack(
                    children: [
                      SizedBox(
                          height: 75,
                          width: double.infinity,
                          child: Image.asset("assets/images/migoreng.jpg",
                              fit: BoxFit.fitWidth)),
                      Positioned.fill(
                          child: Center(child: Text("Noodle", style: TextStyle(
                              color: Colors.white, fontSize: 30),)))
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10))),
                  child: Stack(
                    children: [
                      SizedBox(
                          height: 75,
                          width: double.infinity,
                          child: Image.asset(
                              "assets/images/pizza.jpg", fit: BoxFit.fitWidth)),
                      Positioned.fill(
                          child: Center(child: Text("Pizza", style: TextStyle(
                              color: Colors.white, fontSize: 30),)))
                    ],
                  ),
                ),
                SizedBox(height: 5,)
              ],
            ),
          ),
        ),
      ),
    ),);

  }
}

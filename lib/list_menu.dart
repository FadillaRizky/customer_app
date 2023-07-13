import 'package:flutter/material.dart';

class MenuList extends StatefulWidget {
  const MenuList({Key? key,}) : super(key: key);

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      backgroundColor: Color(0xFF399D44),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Drinks",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/coffee");
                  },
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 75,
                            width: double.infinity,
                            child: Image.asset("assets/images/coffee.jpg",
                                fit: BoxFit.fitWidth)),
                        Positioned.fill(
                            child: Center(
                                child: Text(
                          "Coffee",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        )))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/noncoffee");
                  },
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 75,
                            width: double.infinity,
                            child: Image.asset("assets/images/mojito.jpg",
                                fit: BoxFit.fitWidth)),
                        Positioned.fill(
                            child: Center(
                                child: Text(
                          "Non Coffee",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        )))
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pushNamed(context, "/juice");
                //   },
                //   child: Card(
                //     clipBehavior: Clip.hardEdge,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10))),
                //     child: Stack(
                //       children: [
                //         SizedBox(
                //             height: 75,
                //             width: double.infinity,
                //             child: Image.asset("assets/images/juice.jpg",
                //                 fit: BoxFit.fitWidth)),
                //         Positioned.fill(
                //             child: Center(
                //                 child: Text(
                //           "Juice",
                //           style: TextStyle(color: Colors.white, fontSize: 30),
                //         )))
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Food",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pushNamed(context, "/rice");
                //   },
                //   child: Card(
                //     clipBehavior: Clip.hardEdge,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10))),
                //     child: Stack(
                //       children: [
                //         SizedBox(
                //             height: 75,
                //             width: double.infinity,
                //             child: Image.asset("assets/images/nasigoreng.jpg",
                //                 fit: BoxFit.fitWidth)),
                //         Positioned.fill(
                //             child: Center(
                //                 child: Text(
                //           "Rice",
                //           style: TextStyle(color: Colors.white, fontSize: 30),
                //         )))
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 5,
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/noodle");
                  },
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 75,
                            width: double.infinity,
                            child: Image.asset("assets/images/migoreng.jpg",
                                fit: BoxFit.fitWidth)),
                        Positioned.fill(
                            child: Center(
                                child: Text(
                          "Noodle",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        )))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/snack");
                  },
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 75,
                            width: double.infinity,
                            child: Image.asset("assets/images/snack.jpg",
                                fit: BoxFit.fitWidth)),
                        Positioned.fill(
                            child: Center(
                                child: Text(
                          "Snack",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        )))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
      
      
    );
  }
}

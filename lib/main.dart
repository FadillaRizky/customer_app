import 'package:customer_app/firebase_options.dart';
import 'package:customer_app/list_menu.dart';
import 'package:customer_app/list_menu/noncoffee.dart';
import 'package:customer_app/list_menu/noodle.dart';
import 'package:customer_app/list_menu/snack.dart';
// import 'package:customer_app/list_menu/rice.dart';
import 'package:customer_app/scan_barcode.dart';
import 'package:customer_app/view_barcode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'detail_cart.dart';
import 'list_menu/coffee.dart';
import 'menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ScanBarcode(),
        '/menu': (context) => MenuList(),

        /// list menu
        '/coffee': (context) => Coffee(),
        '/noncoffee': (context) => Noncoffee(),
        // '/rice': (context) => Rice(),
        '/noodle': (context) => Noodle(),
        '/snack': (context) => Snack(),

        /// detail cart
        '/detailcart': (context) => DetailCart(),

        ///qr view
        '/qrview': (context) => QrView(),
      },
    );
  }
}
import 'dart:io';

import 'package:customer_app/firebase_options.dart';
import 'package:customer_app/get_meja.dart';
import 'package:customer_app/list_menu.dart';
import 'package:customer_app/list_menu/noncoffee.dart';
import 'package:customer_app/list_menu/noodle.dart';
import 'package:customer_app/list_menu/snack.dart';
import 'package:customer_app/shared_pref.dart';
import 'package:flutter/foundation.dart';
// import 'package:customer_app/list_menu/rice.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:customer_app/scan_barcode.dart';
import 'package:customer_app/view_barcode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'detail_cart.dart';
import 'list_menu/coffee.dart';
import 'menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initHive();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
Future<void> initHive() async {
  // For web hive does not need to be initialized.
  if (!kIsWeb) {
    var dir = (await getApplicationDocumentsDirectory()).path;
    Hive.init(dir);
  }
  
  await Hive.openBox('cart');
  var box = Hive.box('cart');


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String noMeja = "26";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ScanBarcode(),
        '/menu': (context) => MenuList(),
        '/getMeja': (context) => WidgetMeja(),

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
      onGenerateRoute: (settings) {
        if (settings.name!.startsWith("/getMeja")) {
          String uidNoMeja = "";
          final settingsUri = Uri.parse(settings.name.toString());
          uidNoMeja = settingsUri.queryParameters['no_meja'].toString();
          GetMeja.QrMeja(uidNoMeja, context);
        }
      },
      builder: EasyLoading.init(),
    );
  }
}

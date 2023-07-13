import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import "package:firebase_database/firebase_database.dart";


// part 'data.g.dart';

// This class stores the player progress presistently.
@HiveType(typeId: 0)
class DatabaseHive extends HiveObject {
  @HiveField(0)
  String _id = "";

  @HiveField(1)
  String _nameProduct = "";
  
  @HiveField(2)
  String _price = "";
  
  @HiveField(3)
  String _qty = "";
  
  @HiveField(4)
  String _totalPrice = "";
}
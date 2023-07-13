// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'database_hive.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class DataAdapter extends TypeAdapter<DatabaseHive> {
//   @override
//   final int typeId = 0;

//   @override
//   DatabaseHive read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return DatabaseHive()
//       .._cart = fields[0] as List<Map<String,dynamic>>;
//       // .._nameProduct = fields[1] as String
//       // .._price = fields[2] as String
//       // .._qty = fields[3] as String
//       // .._totalPrice = fields[4] as String;
//   }

//   @override
//   void write(BinaryWriter writer, DatabaseHive obj) {
//     writer
//       ..writeByte(1)
//       ..writeByte(1)
//       ..write(obj._cart);
//       // ..writeByte(1)
//       // ..write(obj._nameProduct)
//       // ..writeByte(2)
//       // ..write(obj._price)
//       // ..writeByte(3)
//       // ..write(obj._qty)
//       // ..writeByte(4)
//       // ..write(obj._totalPrice);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is DataAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
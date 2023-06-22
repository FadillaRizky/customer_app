import 'package:shared_preferences/shared_preferences.dart';

import 'data_user.dart';


class LoginPref {
  static Future<bool> saveToSharedPref(String noMeja) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("noMeja")) {
      pref.remove("noMeja");
    }
    pref.setString("noMeja", noMeja);

    return true;
  }

  static Future<bool> checkPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //jika ada maka bernilai true, jika tidak maka bernilai false
    bool status = pref.containsKey("noMeja");

    return status;
  }
  //cara untuk mengambil nilai pref
  static Future <DataUser> getPref() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    DataUser dataUser = DataUser();
    dataUser.noMeja = pref.getString("noMeja");
    return dataUser;
  }
  static Future<bool> removePref() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("noMeja");
    return true;
  }
}

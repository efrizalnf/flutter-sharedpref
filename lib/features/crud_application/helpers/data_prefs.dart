import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DataPrefs {
  static getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String savedData = prefs.getString('fugi_key') ?? '[]';

    return json.decode(savedData);
  }

  static saveData(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fugi_key', json.encode(data));
  }
}

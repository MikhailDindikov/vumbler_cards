

import 'package:shared_preferences/shared_preferences.dart';

class VumblerStorage {
  static SharedPreferences? vumblerStorage;

  static Future<(List, List<bool>)> vumbler() async {
    vumblerStorage = await SharedPreferences.getInstance();
    return ([], [false, true, false]);
  }
}

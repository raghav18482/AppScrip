import 'package:shared_preferences/shared_preferences.dart';

class Cache{
  Future<void> addSharedprefs(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getsharedprefs(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void removetoSharedprefs(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Object? ab;
    if (key == "count") {
      ab = prefs.getStringList(key);
    } else {
      ab = prefs.getString(key);
    }
    // ignore: unrelated_type_equality_checks
    if (ab != null || ab != Null) {
      await prefs.remove(key);
    }
  }
}
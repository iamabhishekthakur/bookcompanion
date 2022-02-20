import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHandler {
  late SharedPreferences _sharedPreferences;

  Future<void> setSelectedProfileID(String profileID) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('selected_profile_id', profileID);
  }

  Future<String?> getSelectedProfileID() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('selected_profile_id');
  }
}

final sharedPreferenceHandler = SharedPreferenceHandler();

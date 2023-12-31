import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {

  final GetStorage _boxStorage = GetStorage();
  final _key = 'isDarkMode';

  _saveThemeToBox(bool isDarkMode){
    _boxStorage.write(_key, isDarkMode);
  }

  bool _loadThemeFromBox(){
    return _boxStorage.read<bool>(_key) ?? false;
  }

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark;

  void switchTheme(){
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

}
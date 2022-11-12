import 'package:flutter/material.dart';

class RequestBlood with ChangeNotifier{
  List<String> _bloods =[];
  List<String> get bloods{
    return [..._bloods];
  }

  void addBloods(String bloodType){
    _bloods.add(bloodType);
    print(_bloods);
    notifyListeners();
  }
  void removeBloods(String bloodType){
    _bloods.removeWhere((element) => element == bloodType);
    print(_bloods);
    notifyListeners();
  }
  void emptyBloodList(){
    _bloods = [];
    notifyListeners();
  }
}
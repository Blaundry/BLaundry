import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  // Initial state for user
  UserModel _user = UserModel(
    username: "Khidir Julian",
    password: "••••••••••••",
    phoneNumber: "+62 812-3456-7890",
    address: "Jl. Telekomunikasi No.1, Bandung",
  );

  // Getter for user data
  UserModel get user => _user;

  // Method to update user data
  void updateUser(UserModel newUser) {
    _user = newUser;
    notifyListeners(); // Notify listeners when data changes
  }
  
  
  

  // Method to update specific field (e.g., username, phone, etc.)
  void updateField(String field, String newValue) {
    if (field == "username") {
      _user = _user.copyWith(username: newValue);
    } else if (field == "password") {
      _user = _user.copyWith(password: newValue);
    } else if (field == "phoneNumber") {
      _user = _user.copyWith(phoneNumber: newValue);
    } else if (field == "address") {
      _user = _user.copyWith(address: newValue);
    }
    notifyListeners();
  }
}



import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  int _userId = 123456;
  String _username = "JohnDoe";
  DateTime _dateOfBirth = DateTime(1990, 5, 15);
  String _mobile = "0123456789";
  String _email = "johndoe@example.com";
  String _addressState = "California";
  String _addressSuburb = "San Francisco";
  String _addressDetail = "123 Street Name, Apt 4B";

  bool _editMode = false;

  // Getter cho các trường
  int get userId => _userId;
  String get username => _username;
  DateTime get dateOfBirth => _dateOfBirth;
  String get mobile => _mobile;
  String get email => _email;
  String get addressState => _addressState;
  String get addressSuburb => _addressSuburb;
  String get addressDetail => _addressDetail;

  bool get editMode => _editMode;

  void changeMode() {
    _editMode = !_editMode;
    notifyListeners(); 
  }

  // Hàm cập nhật thông tin người dùng và thông báo cho các listeners
  void updateProfile({
    required String username,
    required String mobile,
    required String email,
    required String addressState,
    required String addressSuburb,
    required String addressDetail,
  }) {
    _username = username;
    _mobile = mobile;
    _email = email;
    _addressState = addressState;
    _addressSuburb = addressSuburb;
    _addressDetail = addressDetail;

    changeMode();

    notifyListeners();  // Thông báo cho tất cả các widget đang lắng nghe
  }
}

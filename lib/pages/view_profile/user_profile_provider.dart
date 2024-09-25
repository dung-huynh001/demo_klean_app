import 'package:KleanApp/pages/view_profile/widgets/user_profile_form.dart';
import 'package:KleanApp/utils/request.dart';
import 'package:KleanApp/utils/token_service.dart';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  int _userId = 123456;
  String _username = "JohnDoe";
  DateTime _dateOfBirth = DateTime(1990, 5, 15);
  String _contactMobile = "0123456789";
  String _contactTel = "johndoe@example.com";
  String _contactEmail = "johndoe@example.com";
  String _addressState = "California";
  String _addressSuburb = "San Francisco";
  String _addressDetail = "123 Street Name, Apt 4B";

  bool _editMode = false;

  // Getter cho các trường
  int get userId => _userId;
  String get username => _username;
  DateTime get dateOfBirth => _dateOfBirth;
  String get mobile => _contactMobile;
  String get email => _contactEmail;
  String get tel => _contactTel;
  String get addressState => _addressState;
  String get addressSuburb => _addressSuburb;
  String get addressDetail => _addressDetail;

  bool get editMode => _editMode;

  final request = new Request();

  void changeMode() {
    _editMode = !_editMode;
    notifyListeners();
  }


  Future<dynamic> fetchData() async {
    String? token = await TokenService.getToken();
    Map<String, dynamic>? tokenData = await TokenService.getTokenData();
    var uId = int.parse(tokenData?['nameidentifier']);

    dynamic response = await request.get("api/Profile/GetProfile/$uId", token) as Map<String, dynamic>;
    _userId = response?['userId'];
    _username = response['username'];
    _dateOfBirth = DateTime.parse(response['dateOfBirth']);
    _contactMobile =  response['contactMobile'];
    _contactTel =  response['contactTel'];
    _contactEmail = response['contactEmail'];
    _addressState =  response['addressState'];
    _addressSuburb =  response['addressSuburb'];
    _addressDetail =  response['addressDetail'];

    

    ChangeNotifier();
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
    _contactMobile = mobile;
    _contactTel = email;
    _addressState = addressState;
    _addressSuburb = addressSuburb;
    _addressDetail = addressDetail;

    changeMode();

    notifyListeners(); // Thông báo cho tất cả các widget đang lắng nghe
  }
}

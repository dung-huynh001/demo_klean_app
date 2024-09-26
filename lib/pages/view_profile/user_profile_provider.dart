import 'package:KleanApp/common/constants/vn_address.dart';
import 'package:KleanApp/pages/view_profile/widgets/user_profile_form.dart';
import 'package:KleanApp/utils/request.dart';
import 'package:KleanApp/utils/token_service.dart';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  int? userId;
  String? username;
  DateTime? dateOfBirth;
  String? contactMobile;
  String? contactEmail;
  String? contactTel;
  String? addressState;
  String? addressSuburb;
  String? addressDetail;
  bool editMode = false;

  final request = Request();

  void changeMode() {
    editMode = !editMode;
    notifyListeners();
  }

  Future<dynamic> fetchData() async {
    String? token = await TokenService.getToken();
    Map<String, dynamic>? tokenData = await TokenService.getTokenData();
    var uId = int.parse(tokenData?['nameidentifier']);

    dynamic response = await request.get("api/Profile/GetProfile/$uId", token)
        as Map<String, dynamic>;
    print(response);
    userId = uId;
    username = response['username'];
    dateOfBirth = DateTime.parse(response['dateOfBirth']);
    contactMobile = response['contactMobile'] ?? "";
    contactTel = response['contactTel'] ?? "";
    contactEmail = response['contactEmail'] ?? "";
    addressState = VNAddress.getState(int.parse(response['addressState'])) ?? "";
    addressSuburb = VNAddress.getState(int.parse(response['addressSuburb'])) ?? "";
    addressDetail = response['addressDetail']?.toString() ?? "";

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
    username = username;
    contactMobile = mobile;
    contactTel = email;
    addressState = addressState;
    addressSuburb = addressSuburb;
    addressDetail = addressDetail;

    changeMode();

    notifyListeners(); // Thông báo cho tất cả các widget đang lắng nghe
  }
}

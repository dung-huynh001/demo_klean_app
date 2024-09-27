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
  String? postCode;
  bool editMode = false;
  bool isAddressChanged = false;

  late TextEditingController dateOfBirthController;
  late TextEditingController mobileController;
  late TextEditingController telController;
  late TextEditingController emailController;
  late TextEditingController addressDetailController;

  void initEditorController() {
    dateOfBirthController =
        TextEditingController(text: _formatDate(dateOfBirth ?? DateTime.now()));
    mobileController = TextEditingController(text: contactMobile);
    telController = TextEditingController(text: contactTel);
    emailController = TextEditingController(text: contactEmail);
    addressDetailController = TextEditingController(text: addressDetail);
  }

  final List<Map<String, dynamic>> _states = VNAddress.getStates();
  List<Map<String, dynamic>>? _suburbs;

  final request = Request();

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void changeMode() {
    editMode = !editMode;
    notifyListeners();
  }

  void enableEditMode() {
    editMode = true;
    notifyListeners();
  }

  void SaveAll() {
    editMode = false;
    isAddressChanged = false;
    notifyListeners();
  }

  List<DropdownMenuItem<Object>>? initStates() {
    return _states
        .map((state) =>
            DropdownMenuItem(value: state['id'], child: Text(state['state'])))
        .toList();
  }

  List<DropdownMenuItem<Object>>? initSuburbs() {
    return _suburbs
        ?.map((suburb) =>
            DropdownMenuItem(value: suburb['id'], child: Text(suburb['name'])))
        .toList();
  }

  Future<dynamic> fetchData() async {
    String? token = await TokenService.getToken();
    Map<String, dynamic>? tokenData = await TokenService.getTokenData();
    var uId = int.parse(tokenData?['nameidentifier']);

    dynamic response = await request.get("api/Profile/GetProfile/$uId", token)
        as Map<String, dynamic>;
    userId = uId;
    username = response['username'];
    dateOfBirth = DateTime.parse(response['dateOfBirth']);
    contactMobile = response['contactMobile'] ?? "";
    contactTel = response['contactTel'] ?? "";
    contactEmail = response['contactEmail'] ?? "";
    addressState = response['addressState'];
    addressSuburb = response['addressSuburb'];
    addressDetail = response['addressDetail']?.toString() ?? "";
    postCode = response['postCode']?.toString() ?? "";
    if (addressState != null) {
      _suburbs = VNAddress.getSuburbs(int.parse(addressState ?? ""));
    }

    notifyListeners();
  }

  handleStateChange(val) {
    addressState = val.toString();
    _suburbs = VNAddress.getSuburbs(int.parse(addressState.toString()));
    addressSuburb = null;
    isAddressChanged = true;
    notifyListeners();
  }

  handleSuburbChange(val) {
    addressSuburb = val.toString();
    postCode = VNAddress.getPostCode(int.parse(addressState.toString()),
        int.parse(addressSuburb.toString()));
    isAddressChanged = true;
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

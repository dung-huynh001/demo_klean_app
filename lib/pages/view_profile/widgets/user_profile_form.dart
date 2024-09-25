import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/pages/view_profile/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  bool _editMode = false;

  // Dữ liệu giả lập cho profile user
  final UserProfile user = UserProfile(
    userId: 123456,
    username: "JohnDoe",
    dateOfBirth: DateTime(1990, 5, 15),
    mobile: "0123456789",
    email: "johndoe@example.com",
    tel: "johndoe@example.com",
    addressState: "California",
    addressSuburb: "San Francisco",
    addressDetail: "123 Street Name, Apt 4B",
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.all(AppDefaults.padding),
        decoration: const BoxDecoration(
          color: AppColors.bgSecondaryLight,
          borderRadius:
              BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
        ),
        child: Column(
          children: [
            _buildProfileField('User ID', provider.userId.toString()),
            _buildProfileField('Username', provider.username),
            _buildProfileField('Date of Birth', _formatDate(user.dateOfBirth),
                enableEdit: true),
            _buildProfileField('Mobile', provider.mobile, enableEdit: true),
            _buildProfileField('Email', provider.email, enableEdit: true),
            _buildProfileField('Tel', provider.tel, enableEdit: true),
            _buildProfileField('State', provider.addressState),
            _buildProfileField('Suburb', provider.addressSuburb),
            _buildProfileField('Address Detail', provider.addressDetail,
                enableEdit: true),
          ],
        ),
      ),
    );
  }

  // Widget để tạo các field của profile
  Widget _buildProfileField(String label, String value,
      {bool enableEdit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              h4,
              _editMode
                  ? TextFormField()
                  : Text(
                      value,
                      style: const TextStyle(fontSize: 16.0),
                    ),
              const Divider(),
            ],
          ),
          if (enableEdit)
            IconButton(
                onPressed: () {},
                color: AppColors.iconGrey,
                icon: const Icon(Icons.edit_square))
        ],
      ),
    );
  }

  // Hàm format DateTime thành chuỗi ngày tháng
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class UserProfile {
  final int userId;
  final String username;
  final DateTime dateOfBirth;
  final String mobile;
  final String email;
  final String tel;
  final String addressState;
  final String addressSuburb;
  final String addressDetail;

  UserProfile({
    required this.userId,
    required this.username,
    required this.dateOfBirth,
    required this.mobile,
    required this.email,
    required this.tel,
    required this.addressState,
    required this.addressSuburb,
    required this.addressDetail,
  });
}

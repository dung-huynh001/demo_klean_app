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
    addressState: "California",
    addressSuburb: "San Francisco",
    addressDetail: "123 Street Name, Apt 4B",
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) => Column(
        children: [
          // Field UserId
          _buildProfileField('User ID', user.userId.toString()),

          // Field Username
          _buildProfileField('Username', user.username),

          // Field Date of Birth
          _buildProfileField('Date of Birth', _formatDate(user.dateOfBirth)),

          // Field Mobile
          _buildProfileField('Mobile', user.mobile),

          // Field Email
          _buildProfileField('Email', user.email),

          // Field Address Detail
          _buildProfileField('Address Detail', user.addressDetail),
        ],
      ),
    );
  }

  // Widget để tạo các field của profile
  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
  final String addressState;
  final String addressSuburb;
  final String addressDetail;

  UserProfile({
    required this.userId,
    required this.username,
    required this.dateOfBirth,
    required this.mobile,
    required this.email,
    required this.addressState,
    required this.addressSuburb,
    required this.addressDetail,
  });
}

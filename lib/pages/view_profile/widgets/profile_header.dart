import 'package:KleanApp/Utils/token_service.dart';
import 'package:KleanApp/common/constants/config.dart';
import 'package:KleanApp/pages/view_profile/user_profile_provider.dart';
import 'package:KleanApp/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.drawerKey});

  final GlobalKey<ScaffoldState> drawerKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, child) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding, vertical: AppDefaults.padding),
        color: AppColors.bgSecondaryLight,
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  context.go('/');
                },
                icon: const Badge(
                    isLabelVisible: false, child: Icon(Icons.arrow_back)),
              ),
              const Text("Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              Tooltip(
                message: !userProfileProvider.editMode ? "Edit" : "Save all",
                child: TextButton(
                    onPressed: () {
                      userProfileProvider.changeMode();
                      print(userProfileProvider.editMode);
                    },
                    child: Icon(
                      !userProfileProvider.editMode
                          ? Icons.edit_square
                          : Icons.check,
                      color: AppColors.iconBlack,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

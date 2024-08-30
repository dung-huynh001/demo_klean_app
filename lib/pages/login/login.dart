import 'package:KleanApp/common/constants/config.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/common/constants/extensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 296,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDefaults.padding * 1.5,
                      ),
                      child: SvgPicture.asset(AppConfig.logo),
                    ),
                    Text(
                      'Login',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    h24,
                    Text(
                      'Sign in with email address',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    h24,
                    const Divider(),
                    h16,

                    /// EMAIL TEXT FIELD
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/mail_light.svg',
                          height: 16,
                          width: 20,
                          fit: BoxFit.none,
                        ),
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/check_filled.svg',
                          width: 17,
                          height: 11,
                          fit: BoxFit.none,
                          colorFilter: AppColors.success.toColorFilter,
                        ),
                        hintText: 'Your email',
                      ),
                    ),
                    h16,

                    /// PASSWORD TEXT FIELD
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/lock_light.svg',
                          height: 16,
                          width: 20,
                          fit: BoxFit.none,
                        ),
                        hintText: 'Password',
                      ),
                    ),
                    h16,

                    /// SIGN IN BUTTON
                    SizedBox(
                      width: 296,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Sign in'),
                      ),
                    ),
                    h24,

                    /// SIGNUP TEXT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account?',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textGrey),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              color: AppColors.titleLight,
                            ),
                          ),
                          onPressed: () => context.go('/register'),
                          child: const Text('Sign up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

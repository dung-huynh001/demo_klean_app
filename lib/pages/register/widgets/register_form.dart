import 'package:KleanApp/common/constants/extensions.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 296,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Signup',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              h24,
              Text(
                'Sign up with Open account',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              h24,
              h24,
              const Divider(),
              h24,
              Text(
                'Or continue with email address',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              h16,

              /// EMAIL FIELD
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

              /// CONTINUE BUTTON
              SizedBox(
                width: 296,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Continue'),
                ),
              ),
              h24,
              Text(
                'This site is protected by reCAPTCHA and the Google Privacy Policy.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

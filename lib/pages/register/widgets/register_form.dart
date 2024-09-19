import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:KleanApp/common/constants/vn_address.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/colors.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  int _step = 1;
  int? _addressState;
  int? _addressSuburb;
  String? _postCode;
  DateTime? _dateOfBirth;
  List<Map<String, dynamic>>? _suburbs;
  final List<Map<String, dynamic>> _states = VNAddress.getStates();

  // State variables for validation messages
  String? _userIdError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _dobError;

  bool _isInputValid(String val, {int minLength = 8}) =>
      val.isNotEmpty && val.length >= minLength;

  Future<void> _pickDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
        _dateOfBirthController.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  void _nextStep() {
    setState(() {
      // Reset validation messages
      _userIdError = null;
      _usernameError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _dobError = null;

      switch (_step) {
        case 1:
          if (!_isInputValid(_userIdController.text)) {
            _userIdError = 'User ID is required and must be 8 characters.';
            break;
          }
          _step++;
          break;

        case 2:
          if (!_isInputValid(_usernameController.text)) {
            _usernameError =
                'Username is required and must be at least 8 characters.';
            break;
          }
          _step++;
          break;

        case 3:
          if (!_isInputValid(_passwordController.text)) {
            _passwordError =
                'Password is required and must be at least 8 characters.';
            break;
          }
          if (_passwordController.text != _confirmPasswordController.text) {
            _confirmPasswordError = 'Passwords do not match.';
            break;
          }
          _step++;
          break;

        case 4:
          if (_dateOfBirth == null) {
            _dobError = 'Date of birth is required.';
            break;
          }
          _step++;
          break;

        default:
          break;
      }
    });
  }

  void _prevStep() {
    if (_step > 1) setState(() => _step--);
  }

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
              Text('Sign Up',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              h24,
              Text('Register a new account',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              h16,
              const Divider(),
              if (_step > 1) _buildPreviousButton(),
              SizedBox(
                height: 200,
                width: 296,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    h16,
                    if (_step == 1) _buildUserIdField(),
                    if (_step == 2) _buildUsernameField(),
                    if (_step == 3) _buildPasswordFields(),
                    if (_step == 4) _buildDOBField(),
                    if (_step == 5) _buildAddressField(),
                  ],
                ),
              ),
              h24,
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    int? maxLength,
    String? errorMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      obscureText: obscureText && !_visiblePassword,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      onTapOutside: (pointer) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        errorText: errorMessage,
        suffixIcon: obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _visiblePassword = !_visiblePassword;
                  });
                },
                icon: Icon(
                    _visiblePassword ? Icons.visibility_off : Icons.visibility))
            : null,
      ),
    );
  }

  bool _visiblePassword = false;
  bool _visibleConfirmPassword = false;

  Widget _buildUserIdField() {
    return _buildInputField(
      controller: _userIdController,
      label: 'User ID',
      hintText: 'Enter 8-digit ID',
      icon: Icons.verified_user_sharp,
      errorMessage: _userIdError,
      keyboardType: TextInputType.number,
      maxLength: 8,
    );
  }

  Widget _buildUsernameField() {
    return _buildInputField(
      controller: _usernameController,
      label: 'Username',
      hintText: 'Enter username',
      icon: Icons.person,
      errorMessage: _usernameError,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_visiblePassword,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onTapOutside: (pointer) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            labelText: "Password",
            hintText: "Enter password",
            prefixIcon: const Icon(Icons.lock),
            border: const OutlineInputBorder(),
            errorText: _passwordError,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _visiblePassword = !_visiblePassword;
                  });
                },
                icon: Icon(_visiblePassword
                    ? Icons.visibility_off
                    : Icons.visibility)),
          ),
        ),
        h16,
        TextFormField(
          controller: _confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_visibleConfirmPassword,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onTapOutside: (pointer) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            labelText: "Confirm Password",
            hintText: "Re-enter password",
            prefixIcon: const Icon(Icons.lock),
            border: const OutlineInputBorder(),
            errorText: _confirmPasswordError,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _visibleConfirmPassword = !_visibleConfirmPassword;
                  });
                },
                icon: Icon(_visibleConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility)),
          ),
        ),
      ],
    );
  }

  Widget _buildDOBField() {
    return TextFormField(
      controller: _dateOfBirthController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Date of Birth",
        hintText: 'Select your date of birth',
        errorText: _dobError,
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
      onTap: () => _pickDOB(context),
    );
  }

  Widget _buildAddressField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton(
          value: _addressState,
          isExpanded: true,
          hint: const Text('Select state'),
          items: _states
              .map((state) => DropdownMenuItem(
                  value: state['id'], child: Text(state['state'])))
              .toList(),
          onChanged: (val) {
            setState(() {
              _addressState = val as int?;
              _suburbs = VNAddress.getSuburbs(_addressState);
              _addressSuburb = null;
            });
          },
        ),
        h16,
        DropdownButton(
          value: _addressSuburb,
          isExpanded: true,
          hint: const Text('Select suburb'),
          items: _suburbs
              ?.map((suburb) => DropdownMenuItem(
                  value: suburb['id'], child: Text(suburb['name'])))
              .toList(),
          onChanged: (val) {
            setState(() {
              _addressSuburb = val as int?;
              _postCode =
                  VNAddress.getPostCode(_addressState!, _addressSuburb!);
            });
          },
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: 296,
      child: _step < 5
          ? ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _nextStep();
              },
              child: const Text('Continue'))
          : ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _handleSubmit();
              },
              child: const Text('Submit')),
    );
  }

  Widget _buildPreviousButton() {
    return TextButton.icon(
      onPressed: _prevStep,
      icon: const Icon(Icons.arrow_back),
      label: const Text('Back',
          style:
              TextStyle(color: Colors.black, decoration: TextDecoration.none)),
    );
  }

  void _handleSubmit() {
    print("state: $_addressState");
    print("suburb: $_addressSuburb");
    print("postcode: $_postCode");
  }
}

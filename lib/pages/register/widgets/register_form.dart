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
  DateTime? _dateOfBirth;
  List<Map<String, dynamic>>? _suburbs;
  final List<Map<String, dynamic>> _states = VNAddress.getStates();

  // State variables for validation messages
  String? _userIdError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;

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

      if (_step == 1 && _isInputValid(_userIdController.text)) {
        _step++;
      } else if (_step == 1) {
        _userIdError = 'User ID is required and must be 8 characters.';
      } else if (_step == 2 && _isInputValid(_usernameController.text)) {
        _step++;
      } else if (_step == 2) {
        _usernameError =
            'Username is required and must be at least 8 characters.';
      } else if (_step == 3 && _isInputValid(_passwordController.text)) {
        if (_passwordController.text == _confirmPasswordController.text) {
          _step++;
        } else {
          _confirmPasswordError = 'Passwords do not match.';
        }
      } else if (_step == 3) {
        _passwordError =
            'Password is required and must be at least 8 characters.';
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
              h16,
              if (_step == 1) _buildUserIdField(),
              if (_step == 2) _buildUsernameField(),
              if (_step == 3) _buildPasswordFields(),
              if (_step == 4) _buildDOBField(),
              if (_step == 5) _buildAddressField(),
              h24,
              _buildContinueButton(),
              if (_step > 1) _buildPreviousButton(),
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
    int? maxLength,
    String? errorMessage,
    TextInputType keyboardType = TextInputType.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        errorText: errorMessage,
      ),
    );
  }

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
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          controller: _passwordController,
          label: 'Password',
          hintText: 'Enter password',
          icon: Icons.lock,
          errorMessage: _passwordError,
          keyboardType: TextInputType.visiblePassword,
        ),
        h16,
        _buildInputField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          hintText: 'Re-enter password',
          icon: Icons.lock,
          errorMessage: _confirmPasswordError,
          keyboardType: TextInputType.visiblePassword,
        ),
      ],
    );
  }

  Widget _buildDOBField() {
    return TextFormField(
      controller: _dateOfBirthController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Date of Birth",
        hintText: 'Select your date of birth',
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      onTap: () => _pickDOB(context),
    );
  }

  Widget _buildAddressField() {
    return Column(
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
            });
          },
        ),
        h16,
        if (_suburbs != null)
          DropdownButton(
            value: _addressSuburb,
            isExpanded: true,
            hint: const Text('Select suburb'),
            items: _suburbs
                ?.map((suburb) => DropdownMenuItem(
                    value: suburb['id'], child: Text(suburb['name'])))
                .toList(),
            onChanged: (val) {
              setState(() => _addressSuburb = val as int?);
            },
          ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: 296,
      child:
          ElevatedButton(onPressed: _nextStep, child: const Text('Continue')),
    );
  }

  Widget _buildPreviousButton() {
    return TextButton.icon(
      onPressed: _prevStep,
      icon: const Icon(Icons.arrow_back),
      label: const Text('Previous',
          style:
              TextStyle(color: Colors.black, decoration: TextDecoration.none)),
    );
  }
}

import 'package:KleanApp/common/constants/colors.dart';
import 'package:KleanApp/common/constants/defaults.dart';
import 'package:KleanApp/common/constants/sizes.dart';
import 'package:KleanApp/common/constants/vn_address.dart';
import 'package:KleanApp/pages/view_profile/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _dateOfBirthController = TextEditingController();
  late TextEditingController _mobileController = TextEditingController();
  late TextEditingController _telController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _addressDetailController = TextEditingController();

  int? _addressState;
  int? _addressSuburb;
  String? _postCode;
  DateTime? _dateOfBirth;
  List<Map<String, dynamic>>? _suburbs;
  final List<Map<String, dynamic>> _states = VNAddress.getStates();

  // State variables for validation messages
  String? _dobError;
  String? _emailError;
  String? _mobileDetailError;
  String? _telDetailError;
  String? _addressDetailError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProfileProvider>(context, listen: false);
      provider.fetchData();
      setState(() {});
    });
  }

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
            _buildDOBField("Date of Birth",
                _formatDate(provider.dateOfBirth ?? DateTime.now()),
                enableEdit: true),
            _buildProfileField('Mobile', provider.contactMobile,
                enableEdit: true,
                controller: _mobileController,
                hintText: 'Enter mobile'),
            _buildProfileField('Email', provider.contactEmail,
                enableEdit: true,
                controller: _emailController,
                hintText: 'Enter email'),
            _buildProfileField('Tel', provider.contactTel,
                enableEdit: true,
                controller: _telController,
                hintText: 'Enter tel'),
            // _buildProfileField('State', provider.addressState),
            // _buildProfileField('Suburb', provider.addressSuburb),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "State",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                h4,
                DropdownButton(
                  value: provider.addressState != null
                      ? int.parse(provider.addressState!)
                      : null,
                  isExpanded: true,
                  hint: const Text("Select state"),
                  icon: const Icon(Icons.location_on),
                  items: provider.initStates(),
                  onChanged: (val) {
                    provider.handleStateChange(val);
                  },
                ),
                const Divider(),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Suburb",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                h4,
                DropdownButton(
                  value: provider.addressSuburb != null
                      ? int.parse(provider.addressSuburb!)
                      : null,
                  isExpanded: true,
                  hint: const Text("Select suburb"),
                  icon: const Icon(Icons.location_on),
                  items: provider.initSuburbs(),
                  onChanged: (val) {
                    provider.handleSuburbChange(val);
                  },
                ),
                const Divider(),
              ],
            ),
            _buildProfileField('Address Detail', provider.addressDetail,
                enableEdit: true,
                controller: _addressDetailController,
                hintText: 'Enter address detail'),
          ],
        ),
      ),
    );
  }

  bool _isInputValid(String val, {int minLength = 8}) {
    return val.isNotEmpty && val.length >= minLength;
  }

  Widget _buildDOBField(String label, String? value,
      {bool enableEdit = false,
      String hintText = '',
      TextEditingController? controller,
      String? errorMessage}) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) => Padding(
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
                const SizedBox(height: 4),
                provider.editMode && enableEdit
                    ? SizedBox(
                        width: 296,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _dateOfBirthController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Select your date of birth',
                                errorText: _dobError,
                                suffixIcon: const Icon(Icons.calendar_today),
                                border: const OutlineInputBorder(),
                              ),
                              onTap: () => _pickDOB(context),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        value ?? "",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    String? errorMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        errorText: errorMessage,
      ),
    );
  }

  Widget _buildProfileField(String label, String? value,
      {bool enableEdit = false,
      String hintText = '',
      TextEditingController? controller,
      String? errorMessage}) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) => Padding(
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
                const SizedBox(height: 4),
                provider.editMode && enableEdit
                    ? SizedBox(
                        width: 296,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildInputField(
                                controller:
                                    controller ?? TextEditingController(),
                                hintText: hintText,
                                errorMessage: errorMessage)
                          ],
                        ),
                      )
                    : Text(
                        value ?? "",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

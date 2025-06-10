// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _gender = 'Male';
  bool _isLoading = false;

  Future<void> _submitProfile() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userData = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'username': _usernameController.text.trim(),
      'age': int.parse(_ageController.text),
      'bloodGroup': _bloodGroupController.text.trim(),
      'weight': double.parse(_weightController.text),
      'height': double.parse(_heightController.text),
      'gender': _gender,
      'email': user.email,
      'uid': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true)); // ✅ this line ensures merging
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print("Error saving user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save user details")),
      );
    }
  }

  setState(() => _isLoading = false);
}


  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white),
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/form.jpg', fit: BoxFit.cover),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.775)),
          ),

          // Scrollable form content
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "Complete Your Profile",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Name Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _firstNameController,
                            "First Name",
                            Icons.person,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            _lastNameController,
                            "Last Name",
                            Icons.person_outline,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildTextField(
                      _usernameController,
                      "Username",
                      Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _ageController,
                      "Age",
                      Icons.cake,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: "Blood Group",
                      icon: Icons.water_drop,
                      value:
                          _bloodGroupController.text.isEmpty
                              ? null
                              : _bloodGroupController.text,
                      items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                      onChanged:
                          (val) =>
                              setState(() => _bloodGroupController.text = val!),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _weightController,
                      "Weight (kg)",
                      Icons.fitness_center,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _heightController,
                      "Height (cm)",
                      Icons.height,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: "Gender",
                      icon: Icons.wc,
                      value: _gender,
                      items: ['Male', 'Female', 'Other'],
                      onChanged: (val) => setState(() => _gender = val!),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Save & Continue",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (val) {
        if (val == null || val.trim().isEmpty) return "$label is required";
        if (isNumber) {
          final number = num.tryParse(val);
          if (number == null) return "$label must be a valid number";
          if (label == "Age" && (number <= 0 || number > 120)) {
            return "Enter a valid age";
          }
          if ((label == "Weight (kg)" || label == "Height (cm)") && number <= 0) {
            return "Enter a positive number";
          }
        }
        return null;
      },

      decoration: _inputDecoration(label, icon),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      dropdownColor: Colors.black87,
      decoration: _inputDecoration(label, icon),
      style: const TextStyle(color: Colors.white),
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      validator:
          (val) => val == null || val.isEmpty ? "$label is required" : null,
      onChanged: onChanged,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    _bloodGroupController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}

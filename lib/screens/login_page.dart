import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/data_service.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _keepLoggedIn = false;
  File? _avatarImage;

  Future<void> _pickAvatar() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _avatarImage = File(picked.path));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_avatarImage != null) {
        context.read<DataService>().setAvatar(_avatarImage!.path);
      }
      Navigator.pushReplacementNamed(context, DashboardPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B9E9B),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar selector
                GestureDetector(
                  onTap: _pickAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: _avatarImage != null
                        ? FileImage(_avatarImage!)
                        : const AssetImage(
                                'assets/placeholder_logo.png')
                            as ImageProvider,
                    child: _avatarImage == null
                        ? const Icon(Icons.add_a_photo,
                            size: 30, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 24),

                // App title
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'WellnEase',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Familjen Grotesk',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 80),

                // Heading
                const Text(
                  'Start your\nJourney',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'Montserrat Alternates',
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 40),

                // Login form
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Username',
                            filled: true,
                            fillColor: Color(0xFFF0F0F0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? 'Enter your username' : null,
                          onSaved: (v) => _username = v!.trim(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            filled: true,
                            fillColor: Color(0xFFF0F0F0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                          validator: (v) =>
                              v!.isEmpty ? 'Enter your password' : null,
                          onSaved: (v) => _password = v!.trim(),
                        ),
                        const SizedBox(height: 16),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Keep me logged in'),
                          value: _keepLoggedIn,
                          activeColor: const Color(0xFF493C6B),
                          onChanged: (val) =>
                              setState(() => _keepLoggedIn = val!),
                          controlAffinity:
                              ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF493C6B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Montserrat Alternates',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _submit,
                  child: const Text(
                    'Continue as a guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

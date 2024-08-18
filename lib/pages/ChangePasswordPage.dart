import 'package:flutter/material.dart';
import 'package:driveby/services/api_service.dart';

class ChangePasswordPage extends StatefulWidget {
  final int userId;

  ChangePasswordPage({required this.userId});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late String _oldPassword;
  late String _newPassword;

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await ApiService().changePassword(widget.userId, _oldPassword, _newPassword);
        Navigator.pop(context);
      } catch (e) {
        print('Failed to change password: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Old Password'),
                obscureText: true,
                onSaved: (value) => _oldPassword = value!,
                validator: (value) => value!.isEmpty ? 'Old password is required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                onSaved: (value) => _newPassword = value!,
                validator: (value) => value!.isEmpty ? 'New password is required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

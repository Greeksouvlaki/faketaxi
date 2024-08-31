import 'package:flutter/material.dart';
import 'package:driveby/services/api_service.dart';
import 'package:driveby/models/users.dart';
import 'package:driveby/pages/EditProfilePage.dart';

class AddPaymentMethodPage extends StatefulWidget {
  final int userId;

  AddPaymentMethodPage({required this.userId});

  @override
  _AddPaymentMethodPageState createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedMethod = 'CreditCard';  // Default selection
  String _amount = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedMethod,
                items: ['CreditCard', 'DigitalWallet', 'Cash']
                    .map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMethod = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _amount = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Here, you can make an API call to add the payment method for the user.
      // Example:
      // ApiService().addPaymentMethod(widget.userId, _selectedMethod, _amount);

      Navigator.pop(context); // Go back to the profile page after saving
    }
  }
}

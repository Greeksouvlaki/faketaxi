import 'package:flutter/material.dart';
import 'package:driveby/services/api_service.dart';

class AddPaymentMethodPage extends StatefulWidget {
  final int userId;

  AddPaymentMethodPage({required this.userId});

  @override
  _AddPaymentMethodPageState createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final _formKey = GlobalKey<FormState>();
  int _selectedMethodId = 1; // Change to int for paymentMethodId
  String? _cardNumber;
  String? _expiryDate;
  String? _walletProvider;
  bool _isDefault = false;

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
              DropdownButtonFormField<int>(
                value: _selectedMethodId,  // This should be an int
                items: [
                  DropdownMenuItem(value: 1, child: Text('CreditCard')),
                  DropdownMenuItem(value: 2, child: Text('DigitalWallet')),
                  DropdownMenuItem(value: 3, child: Text('Cash')),
                ],
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedMethodId = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                ),
              ),
              if (_selectedMethodId == 1) ...[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _cardNumber = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Expiry Date'),
                  keyboardType: TextInputType.datetime,
                  onSaved: (value) {
                    _expiryDate = value;
                  },
                ),
              ] else if (_selectedMethodId == 2) ...[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Wallet Provider'),
                  onSaved: (value) {
                    _walletProvider = value;
                  },
                ),
              ],
              CheckboxListTile(
                title: Text("Set as default payment method"),
                value: _isDefault,
                onChanged: (bool? value) {
                  setState(() {
                    _isDefault = value!;
                  });
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

      // Ensure card number and wallet provider are passed correctly
      String? cardNumber = _selectedMethodId == 1 ? _cardNumber : null;
      String? walletProvider = _selectedMethodId == 2 ? _walletProvider : null;

      // Call API to add payment method
      ApiService().addPaymentMethod(
        widget.userId, 
        _selectedMethodId, 
        cardNumber, 
        _expiryDate, 
        walletProvider
      ).then((_) {
        Navigator.pop(context); // Go back to the profile page after saving
      }).catchError((error) {
        print("Error adding payment method: $error");
        // Handle error appropriately in UI
      });
    }
  }
}

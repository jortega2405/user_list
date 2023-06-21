import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_list/bloc/user_bloc.dart';
import 'package:user_list/models/address_model.dart';
import 'package:user_list/models/user_model.dart';

class AddressFormScreen extends StatefulWidget {
  final User user;

  const AddressFormScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<UserBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _streetController,
              decoration: const InputDecoration(labelText: 'Street'),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            TextField(
              controller: _postalCodeController,
              decoration: const InputDecoration(labelText: 'Postal Code'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final address = Address(
                  street: _streetController.text,
                  city: _cityController.text,
                  state: _stateController.text,
                  postalCode: _postalCodeController.text,
                );

                final userId = widget.user.id!;
                userBloc.addAddress(address, userId);
                Navigator.pop(context, true);
              },
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}

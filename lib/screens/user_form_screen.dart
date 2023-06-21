import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_list/bloc/user_bloc.dart';
import 'package:user_list/models/user_model.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthDateController;
  late UserBloc _userBloc;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _birthDateController = TextEditingController();
    _userBloc = Provider.of<UserBloc>(context, listen: false);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    final currentDate = DateTime.now();
    final initialDate = _selectedDate ?? currentDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final birthDate = DateTime.parse(_birthDateController.text);

      final user = User(
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        addresses: [],
      );

      _userBloc.saveUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User saved successfully!'),
        ),
      );
      _userBloc.fetchUserList();
       Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: _showDatePicker,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(labelText: 'Birth Date'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your birth date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

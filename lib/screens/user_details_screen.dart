import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_list/bloc/user_bloc.dart';
import 'package:user_list/models/address_model.dart';
import 'package:user_list/models/user_model.dart';
import 'package:user_list/screens/address_form_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  final User user;

  const UserDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = Provider.of<UserBloc>(context, listen: false);
    _userBloc.getAddressList(widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Details - ${widget.user.firstName} ${widget.user.lastName}',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('First Name: ${widget.user.firstName}'),
                Text('Last Name: ${widget.user.lastName}'),
                Text('Birth Date: ${widget.user.birthDate.toString()}'),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Addresses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Address>>(
              stream: _userBloc.addressListStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final addresses = snapshot.data!;
                  if (addresses.isNotEmpty) {
                    return ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return ListTile(
                          title: Text('Address ${index + 1}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Street: ${address.street}'),
                              Text('City: ${address.city}'),
                              Text('State: ${address.state}'),
                              Text('Postal Code: ${address.postalCode}'),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No addresses found'),
                    );
                  }
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error retrieving addresses'),
                  );
                } else {
                  return const SizedBox(); // No mostrar nada si no hay datos
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressFormScreen(user: widget.user),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
